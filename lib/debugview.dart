library debugview;

import 'package:alice/alice.dart';
import 'package:alice/utils/shake_detector.dart';
import 'package:debugview/dio.extension.dart';
import 'package:debugview/mock.dart';
import 'package:debugview/pages/debugview.page.dart';
import 'package:debugview/utils/extensions.dart';
import 'package:debugview/utils/prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugView {
  static final DebugView _singleton = DebugView._internal();

  factory DebugView() => _singleton;

  DebugView._internal();

  final Alice _aliceInstance = Alice(showNotification: false);

  Alice get alice => _aliceInstance;

  var mockList = <Mock>[];

  bool showNotification = true;

  bool _isDebugViewOpened = false;

  GlobalKey<NavigatorState>? navigatorKey;

  Widget? debugViewContent;

  init({
    List<DebugViewMock>? mockList,
    GlobalKey<NavigatorState>? navigatorKey,
    Dio? dioInstance,
    bool? showNotification,
  }) async {
    await Prefs().init();

    if (mockList != null) {
      this.mockList = mockList.map((e) => e.toMock()).toList();
    }
    if (navigatorKey != null) {
      this.navigatorKey = navigatorKey;
      alice.setNavigatorKey(navigatorKey);
    }
    if (showNotification != null) {
      this.showNotification = showNotification;
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
    debugViewContent = content;
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
          builder: (context) =>
              DebugViewPage(
                debugViewContent: debugViewContent,
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
