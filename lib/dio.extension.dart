import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'debugview.dart';

extension Interceptor on Dio {
  void addDebugViewInterceptors() {
    interceptors.add(DebugView().alice.getDioInterceptor());

    interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.headers.containsKey("mock")) {
          final mockId = options.headers["mock"];
          final mock = DebugView()
              .mockList
              .firstWhere((element) => element.mockId == mockId);
          options.headers.remove("mock");
          if (mock.isActive) {
            final data = await rootBundle.loadString(mock.mockAssetPath);
            return handler.resolve(
              Response(requestOptions: options, data: data),
            );
          }
        }

        return handler.next(options);
      },
    ));
  }
}
