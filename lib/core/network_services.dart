import 'package:dio/dio.dart';

enum NetworkFailureType { message, network }

class NetworkFailure extends DioException {
  int code = 0;

  @override
  String? message = "";
  NetworkFailureType networkFailureType = NetworkFailureType.message;

  NetworkFailure(
      {required super.requestOptions,
      Response? response,
      DioExceptionType type = DioExceptionType.unknown,
      dynamic super.error,
      this.message})
      : super(type: type, response: response) {
    switch (type) {
      case DioExceptionType.cancel:
        message = "Request Cancelled";
        networkFailureType = NetworkFailureType.network;
        break;
      case DioExceptionType.unknown:
        message = "Unable to Connect";
        networkFailureType = NetworkFailureType.network;
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive Timeout";
        networkFailureType = NetworkFailureType.network;
        break;
      case DioExceptionType.sendTimeout:
        message = "Send Timeout";
        networkFailureType = NetworkFailureType.network;
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connect Timeout";
        networkFailureType = NetworkFailureType.network;
        break;

      case DioExceptionType.badCertificate:
        message = "Bad certificate";
        networkFailureType = NetworkFailureType.network;
        break;

      case DioExceptionType.badResponse:
        if (response?.data is Map<String, dynamic>) {
          message = serializeErrors(response!.data);
        } else {
          message = "API didn't return JSON";
        }
        networkFailureType = NetworkFailureType.message;
        break;
      case DioExceptionType.connectionError:
        message = "Connection error";
        networkFailureType = NetworkFailureType.network;
        break;
    }
  }

  String serializeErrors(Map<String, dynamic> data) {
    return data["error"];
  }

  @override
  String toString() {
    return "Network failure: Code $code, Message $message";
  }
}
