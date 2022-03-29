import 'package:debugview/mock.dart';
import 'package:debugview/response.dart';
import 'package:debugview/utils/constants.dart';
import 'package:debugview/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebugMockWidget extends StatefulWidget {
  const DebugMockWidget({
    Key? key,
    required this.mock,
  }) : super(key: key);

  final Mock mock;

  @override
  _DebugMockWidgetState createState() => _DebugMockWidgetState();
}

class _DebugMockWidgetState extends State<DebugMockWidget> {
  late bool isActive;
  late double throttle;
  late String response;

  onMockSwitchToggle(bool isChecked) {
    widget.mock.isActive = isChecked;

    setState(() {
      isActive = isChecked;
    });
  }

  onThrottleSliderChanged(double value) {
    widget.mock.throttle = value.toInt();

    setState(() {
      throttle = value;
    });
  }

  openResponsePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: CupertinoPicker(
          backgroundColor: Colors.grey.shade400,
          itemExtent: 30,
          onSelectedItemChanged: onResponseItemChanged,
          children: [
            ...responses.map(
              (element) => Text(
                element.label.name,
                style: const TextStyle(color: mainColor),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  onResponseItemChanged(int? value) {
    if (value == null) return;
    final newResponse = responses[value].label.name;

    widget.mock.response = newResponse;

    setState(() {
      response = newResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    isActive = widget.mock.isActive ?? false;
    throttle = widget.mock.throttle.toDouble();
    response = widget.mock.response;

    final _headerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.mock.label),
        CupertinoSwitch(
          value: isActive,
          onChanged: onMockSwitchToggle,
        ),
      ],
    );

    final _throttleRow = Row(
      children: [
        const SizedBox(width: 8),
        const Icon(
          CupertinoIcons.arrow_turn_down_right,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          "Throttle ($throttle ms)",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 16),
        const Spacer(),
        CupertinoSlider(
          value: throttle,
          onChanged: onThrottleSliderChanged,
          divisions: 40,
          max: 10000,
        ),
      ],
    );

    final _responseRow = Row(
      children: [
        const SizedBox(width: 8),
        const Icon(
          CupertinoIcons.arrow_turn_down_right,
          size: 12,
        ),
        const SizedBox(width: 4),
        const Text(
          "Response",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 16),
        const Spacer(),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: DebugButtonWidget(
            label: response,
            onPressed: openResponsePicker,
          ),
        ),
      ],
    );

    return Column(
      children: [
        _headerRow,
        _throttleRow,
        _responseRow,
        const SizedBox(height: 32),
      ],
    );
  }
}
