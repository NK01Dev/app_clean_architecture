import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'network_service_interceptor.dart';

final networkServiceProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: 'jsonplaceholder.typicode.com',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
  );
  final dio = Dio(options);
  final NetworkServiceInterceptor = ref.watch(networkServiceInterceptorProvider);
  dio.interceptors.addAll([HttpFormatter(), NetworkServiceInterceptor]);
  return dio;
});
