import 'package:debugview/mock.dart';
import 'package:flutter/cupertino.dart';

class MockSwitchWidget extends StatefulWidget {
  const MockSwitchWidget({
    Key? key,
    required this.mock,
  }) : super(key: key);

  final Mock mock;

  @override
  _MockSwitchWidgetState createState() => _MockSwitchWidgetState();
}

class _MockSwitchWidgetState extends State<MockSwitchWidget> {
  late bool isActive;

  @override
  Widget build(BuildContext context) {
    isActive = widget.mock.isActive;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.mock.label),
        CupertinoSwitch(
          value: isActive,
          onChanged: (isChecked) {
            widget.mock.isActive = isChecked;

            setState(() {
              isActive = isChecked;
            });
          },
        ),
      ],
    );
  }
}
