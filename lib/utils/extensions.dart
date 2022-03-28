import 'package:debugview/dio.extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

extension KeyBind on RawKeyEvent {
  bool isDebugKeyBindsPressed() =>
      this is RawKeyDownEvent &&
      isAltPressed &&
      isControlPressed &&
      isKeyPressed(LogicalKeyboardKey.escape);
}

extension MockableWith on Options {
  Options mockableWith(String mockId) {
    if (headers == null) {
      headers = {mockHeaderKey: mockId};
    } else {
      headers?[mockHeaderKey] = mockId;
    }
    
    return this;
  }
}
