library debugview;

import 'package:alice/alice.dart';
import 'package:alice/utils/shake_detector.dart';
import 'package:debugview/dio.extension.dart';
import 'package:debugview/mock.dart';
import 'package:debugview/utils/prefs.dart';
import 'package:debugview/widgets/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugView {
  static final DebugView _singleton = DebugView._internal();

  final Alice _aliceInstance = Alice(showNotification: false);

  factory DebugView() => _singleton;

  DebugView._internal();

  Alice get alice => _aliceInstance;

  final mockList = <Mock>[];

  init() async {
    await Prefs().init();
  }
}

class DebugViewWidget extends StatefulWidget {
  const DebugViewWidget({
    Key? key,
    required this.child,
    required this.dioInstance,
    this.debugViewContent,
  }) : super(key: key);

  final Widget child;
  final Dio dioInstance;
  final Widget? debugViewContent;

  @override
  _DebugViewWidgetState createState() => _DebugViewWidgetState();
}

class _DebugViewWidgetState extends State<DebugViewWidget> {
  showDebugView() {
    showBottomSheet(
      context: context,
      elevation: 30,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (context) => Container(
        color: const Color(0x26FFFFFF),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: ButtonWidget(
                label: "Network Viewer (Alice)",
                onPressed: () {
                  DebugView().alice.showInspector();
                },
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            if (widget.debugViewContent != null)
              SizedBox(width: double.infinity, child: widget.debugViewContent!),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      widget.dioInstance.addDebugViewInterceptors();
      if (!kIsWeb) {
        ShakeDetector.autoStart(
          shakeSlopTimeMS: 3000,
          onPhoneShake: () {
            print("[DebugView] - onPhoneShake");
            showDebugView();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return kDebugMode && kIsWeb
        ? RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event is RawKeyDownEvent &&
                  event.isAltPressed &&
                  event.isControlPressed &&
                  event.isKeyPressed(LogicalKeyboardKey.escape)) {
                print("[DebugView] - onShortcutPressed");
                showDebugView();
              }
            },
            child: widget.child,
          )
        : widget.child;
  }
}
