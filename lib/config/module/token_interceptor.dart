import 'dart:developer';

import 'package:dio/dio.dart';

import '../cache/secure_cache/cache_keys.dart';
import '../cache/secure_cache/secure_cache_helper.dart';

class TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await SecureCacheHelper.getData(key: CacheKeys.token);
      if (token != null && token.isNotEmpty) {
        options.headers['token'] = token;
      }
    } catch (e) {
      log(e.toString());
    }
    super.onRequest(options, handler);
  }
}
