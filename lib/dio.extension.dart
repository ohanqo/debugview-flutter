import 'dart:convert';

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
            final mock = DebugView.instance.mockList
                .firstWhere((element) => element.mockId == mockId);
            if (mock.isActive == true) {
              final data = await rootBundle.loadString(mock.mockAssetPath);

              if (mock.throttle > 0) {
                await Future.delayed(Duration(milliseconds: mock.throttle));
              }

              return handler.resolve(
                Response(
                  requestOptions: options,
                  data: jsonDecode(data),
                  statusCode: 200,
                  statusMessage: "Ok",
                ),
                true,
              );
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
