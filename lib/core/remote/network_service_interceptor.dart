import 'package:app_clean_architecture/core/data/local/secure_local/isecure_storage.dart';
import 'package:app_clean_architecture/core/data/local/secure_local/secure_storage_const.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/local/secure_local/secure_storage.dart';
final networkServiceInterceptorProvider=Provider<NetworkServiceInterceptor>((ref){
  final secureStorage=ref.watch(secureStorageProvider);
  return NetworkServiceInterceptor(secureStorage);
});

final class NetworkServiceInterceptor  extends Interceptor{
  final IsecureStorage _secureStorage;
  NetworkServiceInterceptor(this._secureStorage);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    // TODO: implement onRequest
    final accessToken= await _secureStorage.read(accessTokenKey);
options.headers['content-type']='application/json';
options.headers['Accept']='application/json';
options.headers['Authorization']='Bearer $accessToken';
    super.onRequest(options, handler);
  }

}