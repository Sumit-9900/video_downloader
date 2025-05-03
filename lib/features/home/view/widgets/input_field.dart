import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Please enter your link!';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.link, color: Colors.grey),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: Icon(Icons.close),
        ),
      ),
    );
  }
}
