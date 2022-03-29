// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';

enum DebugResponseLabel {
  STATUS_200,
  STATUS_201,
  STATUS_204,
  STATUS_304,
  STATUS_400,
  STATUS_401,
  STATUS_403,
  STATUS_404,
  STATUS_409,
  STATUS_410,
  STATUS_500,
  EXCEPTION_CONNECT_TIMEOUT,
  EXCEPTION_SEND_TIMEOUT,
  EXCEPTION_RECEIVE_TIMEOUT,
  EXCEPTION_CANCEL,
  EXCEPTION_OTHER,
}

class DebugResponse {
  const DebugResponse({
    required this.label,
    required this.isError,
    this.status,
    this.dioErrorType,
  });

  final DebugResponseLabel label;
  final bool isError;
  final int? status;
  final DioErrorType? dioErrorType;

  DioError getDioError(RequestOptions options) {
    if (!isError) {
      throw Exception("The response need to be an error…");
    }
    if (dioErrorType == null) {
      throw Exception("The error type need to be specified…");
    }

    Response<dynamic>? response;

    if (status != null) {
      response = Response(requestOptions: options, statusCode: status);
    }

    options.responseType = ResponseType.json;

    return DioError(response: response, requestOptions: options, type: dioErrorType!);
  }
}
