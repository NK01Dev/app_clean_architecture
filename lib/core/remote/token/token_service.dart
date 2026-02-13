 import 'package:app_clean_architecture/core/common/status/status_code.dart';
import 'package:app_clean_architecture/core/data/local/secure_local/secure_storage.dart';
import 'package:app_clean_architecture/core/data/local/secure_local/secure_storage_const.dart';
import 'package:app_clean_architecture/core/remote/token/itoken_service.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/dtos/refresh_token_response.dart';
import '../../data/local/secure_local/isecure_storage.dart';
 final tokenServiceProvider=Provider.family<ITokenService,Dio>((ref,dio){
final secureStorage=ref.watch(secureStorageProvider);
   return TokenService(dio,secureStorage);
 });

class TokenService  implements ITokenService{
  // etape : creation des variable
  Dio _dio;
  ISecureStorage _secureStorage;

  //inject constructor
  TokenService(this._dio, this._secureStorage);

  @override
  Future<void> clearTokens() async{
    // TODO: implement clearTokens
    await _secureStorage.delete( accessTokenKey);
    await _secureStorage.delete( refreshTokenKey);
  }

  @override
  Future<String?> getAccessToken() =>  _secureStorage.read(accessTokenKey);

  @override
  Future<String?> getRefreshToken()=>_secureStorage.read(accessTokenKey);

  @override
  Future<RefreshTokenResponse> refreshToken(String? refreshToken)  async {
    // TODO: implement refreshToken

    final respone= await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );
  if(respone.statusCode==success){
    //get data
    final data=respone.data;
    return RefreshTokenResponse.fromJson(data ?? {});
  }else{
    throw DioException(requestOptions: respone.requestOptions,
    response: respone,
    type: DioExceptionType.badResponse);

  }

  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken)  {
    // TODO: implement saveTokens
return Future.wait([
  _secureStorage.write(accessTokenKey, accessToken),
  _secureStorage.write(refreshTokenKey, refreshToken),]);

  }
}