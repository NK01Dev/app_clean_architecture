import 'package:app_clean_architecture/core/remote/token/itoken_service.dart';
import 'package:app_clean_architecture/core/remote/token/token_service.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common/status/status_code.dart';
final networkServiceInterceptorProvider =
    Provider.family<NetworkServiceInterceptor, Dio>((ref, dio) {
      // final secureStorage = ref.watch(secureStorageProvider);
      final tokenService = ref.watch(tokenServiceProvider(dio));
      return NetworkServiceInterceptor(tokenService, dio);
    });

final class NetworkServiceInterceptor extends Interceptor {
final ITokenService _tokenService;
final Dio _dio;

  NetworkServiceInterceptor(this._tokenService, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: implement onRequest
    final accessToken =_tokenService.getAccessToken();
    options.headers['content-type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['Authorization'] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //handle unauthorized error
    if (err.response?.statusCode == unauthorized) {
      final token = await _tokenService.getRefreshToken();
      try {
       final result= await _tokenService.refreshToken(token);
       final accessToken = result.data.accessToken;
       final refreshToken = result.data.refreshToken;
       await _tokenService.saveTokens(accessToken, refreshToken);

       final options = err.requestOptions;
       // update the request header with the new access toke
       options.headers['Authorization'] = 'Bearer $accessToken';
       // retry the request with the new access token
       final response = await _dio.fetch(options);
       return handler.resolve(response);
      } on DioException catch (e) {
        if (e.response?.statusCode == refreshTokenExpired) {
          // handle the case where the refresh token is expired
          // clear the access token and refresh token from secure storage
          await _tokenService.clearTokens();
          //update statusCode
          // err.response?.statusCode = refreshTokenExpired;
          return handler.next(err);
        }
        //continue with error
        return handler.next(err);
      }
      return handler.next(err);
    }
  }


}
