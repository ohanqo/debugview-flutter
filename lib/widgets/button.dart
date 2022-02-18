import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.white,
      textColor: Colors.redAccent,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.redAccent),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(label),
    );
  }
}
