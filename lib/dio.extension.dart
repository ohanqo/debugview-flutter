import 'package:dio/dio.dart';

import 'debugview.dart';

extension Interceptor on Dio {
  void addDebugViewInterceptors() {
    interceptors.add(DebugView().alice.getDioInterceptor());
  }
}
