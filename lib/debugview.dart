library debugview;

import 'package:alice_lightweight/alice.dart';
import 'package:debugview/dio.extension.dart';
import 'package:debugview/mock.dart';
import 'package:debugview/pages/debugview.page.dart';
import 'package:debugview/utils/extensions.dart';
import 'package:debugview/utils/prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';

class DebugView {
  DebugView._privateConstructor();

  static final DebugView instance = DebugView._privateConstructor();

  final Alice _aliceInstance = Alice();

  Alice get alice => _aliceInstance;

  var mockList = <Mock>[];

  bool _isDebugViewOpened = false;

  GlobalKey<NavigatorState>? navigatorKey;

  Widget? _debugViewContent;

  init({
    List<DebugViewMock>? mockList,
    GlobalKey<NavigatorState>? navigatorKey,
    Dio? dioInstance,
  }) async {
    await Prefs().init();

    if (mockList != null) {
      this.mockList = mockList.map((e) => e.toMock()).toList();
    }
    if (navigatorKey != null) {
      this.navigatorKey = navigatorKey;
      alice.setNavigatorKey(navigatorKey);
    }

    dioInstance?.addDebugViewInterceptors();

    if (!kIsWeb) {
      ShakeDetector.autoStart(
        shakeSlopTimeMS: 3000,
        onPhoneShake: () => navigateToDebugView(),
      );
    }

    RawKeyboard.instance.addListener(_handleKeyboardInteraction);
  }

  setDebugViewContent(Widget content) {
    _debugViewContent = content;
  }

  navigateToDebugView() {
    final context = navigatorKey?.currentState?.overlay?.context;
    if (context == null) {
      debugPrint(
        "Cant start DebugView. Please add NavigatorKey to your application",
      );
      return;
    }
    if (!_isDebugViewOpened) {
      _isDebugViewOpened = true;
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => DebugViewPage(
            debugViewContent: _debugViewContent,
          ),
        ),
      ).then((onValue) => _isDebugViewOpened = false);
    }
  }

  dispose() {
    RawKeyboard.instance.removeListener(_handleKeyboardInteraction);
  }

  _handleKeyboardInteraction(RawKeyEvent event) {
    if (event.isDebugKeyBindsPressed()) {
      navigateToDebugView();
    }
  }
}
