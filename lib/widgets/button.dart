import 'package:debugview/utils/constants.dart';
import 'package:flutter/material.dart';

class DebugButtonWidget extends StatelessWidget {
  const DebugButtonWidget({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.transparent,
      textColor: mainColor,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 1, color: mainColor),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: mainColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
