import 'package:dio/dio.dart';

import 'network_services.dart';

class DioService {
  late final Dio _dio;
  Dio get http => _dio;

  DioService() {
    _dio = Dio();
    _dio.options.baseUrl = "";

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options); //continue
        },
        onResponse: (response, handler) {
          return handler.next(response); // continue
        },
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.badResponse) {
            if (e.response!.statusCode == 401) {
              Future.delayed(const Duration(milliseconds: 100), () {
                print("error");
                //401 Status code mainly refers to unauthorization
                //navigate to login screen or do some action.
              });
            }
          }
          return handler.next(
            NetworkFailure(
                requestOptions: e.requestOptions,
                error: e.error,
                response: e.response,
                type: e.type),
          );
        },
      ),
    );
  }
}
