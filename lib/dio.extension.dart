import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'debugview.dart';

const mockHeaderKey = "mock";

extension Interceptor on Dio {
  void addDebugViewInterceptors() {
    interceptors.add(DebugView().alice.getDioInterceptor());

    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.headers.containsKey(mockHeaderKey)) {
            final mockId = options.headers[mockHeaderKey];
            final mock = DebugView()
                .mockList
                .firstWhere((element) => element.mockId == mockId);
            options.headers.remove(mockHeaderKey);
            if (mock.isActive) {
              final data = await rootBundle.loadString(mock.mockAssetPath);
              Map<String, dynamic> map = Map.castFrom(jsonDecode(data));
              return handler.resolve(
                Response(requestOptions: options, data: map),
              );
            }
          }

          return handler.next(options);
        },
      ),
    );
  }
}
