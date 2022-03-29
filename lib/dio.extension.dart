import 'dart:convert';

import 'package:debugview/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'debugview.dart';

const mockHeaderKey = "mock";

extension Interceptor on Dio {
  void addDebugViewInterceptors() {
    interceptors.add(DebugView.instance.alice.getDioInterceptor());

    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.headers.containsKey(mockHeaderKey)) {
            final mockId = options.headers[mockHeaderKey];
            final mock = DebugView.instance.mockList.firstWhere(
              (element) => element.mockId == mockId,
            );

            if (mock.isActive == true) {
              final data = await rootBundle.loadString(mock.mockAssetPath);
              final response = responses.firstWhere(
                (element) => element.label.name == mock.response,
              );

              if (mock.throttle > 0) {
                await Future.delayed(Duration(milliseconds: mock.throttle));
              }

              if (response.isError) {
                return handler.reject(
                  response.getDioError(options),
                  true,
                );
              } else {
                return handler.resolve(
                  Response(
                    requestOptions: options,
                    data: jsonDecode(data),
                    statusCode: response.status ?? 200,
                    statusMessage: "Ok",
                  ),
                  true,
                );
              }
            } else {
              options.headers.remove(mockHeaderKey);
            }
          }

          return handler.next(options);
        },
      ),
    );
  }
}
