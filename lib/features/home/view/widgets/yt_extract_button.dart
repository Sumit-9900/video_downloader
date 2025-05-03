import 'package:flutter/material.dart';

class YtExtractButton extends StatelessWidget {
  final VoidCallback onPressed;
  const YtExtractButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        'Extract',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
