import 'package:debugview/debugview.dart';
import 'package:debugview/mock.dart';
import 'package:debugview/widgets/button.dart';
import 'package:debugview/widgets/mock.dart';
import 'package:flutter/material.dart';

class DebugViewPage extends StatefulWidget {
  const DebugViewPage({Key? key, this.debugViewContent}) : super(key: key);

  final Widget? debugViewContent;

  @override
  _DebugViewPageState createState() => _DebugViewPageState();
}

class _DebugViewPageState extends State<DebugViewPage> {
  List<Mock> mockList = DebugView.instance.mockList;

  buildMockSwitchWidgets() {
    return mockList.map(
      (mock) => DebugMockWidget(
        mock: mock,
      ),
    );
  }

  openNetworkInterceptor() {
    DebugView.instance.alice.showInspector();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debug")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: DebugButtonWidget(
                  label: "Network Viewer",
                  onPressed: openNetworkInterceptor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (widget.debugViewContent != null)
                SizedBox(
                  width: double.infinity,
                  child: widget.debugViewContent!,
                ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              ...buildMockSwitchWidgets(),
            ],
          ),
        ),
      ),
    );
  }
}
