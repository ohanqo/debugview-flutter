import 'package:flutter/services.dart';

extension KeyBind on RawKeyEvent {
  bool isDebugKeyBindsPressed() =>
      this is RawKeyDownEvent &&
      isAltPressed &&
      isControlPressed &&
      isKeyPressed(LogicalKeyboardKey.escape);
}
