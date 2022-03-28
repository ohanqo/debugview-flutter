import 'package:debugview/mock.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    isActive = widget.mock.isActive ?? false;
    throttle = widget.mock.throttle.toDouble();

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

    return Column(
      children: [
        _headerRow,
        _throttleRow,
      ],
    );
  }
}
