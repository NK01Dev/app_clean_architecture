import 'package:app_clean_architecture/core/data/local/secure_local/isecure_storage.dart';
import 'package:app_clean_architecture/core/data/local/secure_local/secure_storage_const.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/dtos/refresh_token_response.dart';
import '../common/status/status_code.dart';
import '../data/local/secure_local/secure_storage.dart';

final networkServiceInterceptorProvider = Provider.family<NetworkServiceInterceptor,Dio>((
  ref,dio
) {
  final secureStorage = ref.watch(secureStorageProvider);
  return NetworkServiceInterceptor(secureStorage,dio);
});

final class NetworkServiceInterceptor extends Interceptor {
  final IsecureStorage _secureStorage;
  final Dio _dio;

  NetworkServiceInterceptor(this._secureStorage, this._dio);

  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler,) async {
    // TODO: implement onRequest
    final accessToken = await _secureStorage.read(accessTokenKey);
    options.headers['content-type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['Authorization'] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //handle unauthorized error
    if (err.response?.statusCode == unauthorized) {
      final token = await _secureStorage.read(refreshTokenKey);
      try {
        final response = await _refreshToken(_dio,token);
        final json = response.data;
        final result = RefreshTokenResponse.fromJson(json ?? {});
        final statusCode = response.statusCode;

        if (statusCode == success) {
          final accessToken = result.data.accessToken;
          final refreshToken = result.data.refreshToken;
          // save the new access token and refresh token to secure storage
       await _updateToken(accessToken, refreshToken);
          final options = err.requestOptions;
          // update the request header with the new access toke
          options.headers['Authorization'] = 'Bearer $accessToken';
          // retry the request with the new access token
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == refreshTokenExpired) {
          // handle the case where the refresh token is expired
          // clear the access token and refresh token from secure storage
          await _clearAccessToken();
          //update statusCode
          err.response?.statusCode = refreshTokenExpired;
          return handler.next(err);
        }
        //continue with error
        return handler.next(err);
      }
      return handler.next(err);
    }
  }

  Future<void> _updateToken(String accessToken, String refreshToken) async {
    await _secureStorage.write(accessTokenKey, accessToken);
    await _secureStorage.write(refreshTokenKey, refreshToken);
  }

  Future<void> _clearAccessToken() async {
    await _secureStorage.delete(accessTokenKey);
    await _secureStorage.delete(refreshTokenKey);
  }
  // refactor method refresh token
Future<Response<Map<String, dynamic>>>_refreshToken(Dio dio,String? token)async {
  return     await dio.post<Map<String, dynamic>>(
    '/api/v1/auth/refresh-token',
    data: {'refreshToken': token},
  );
}
}