import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.hintText = "", required this.controller, this.onSubmitted});

  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      controller: widget.controller,
      onSubmitted: (value) {
        widget.onSubmitted?.call();
      },
      maxLines: 1,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: widget.hintText,
        prefixIcon: const Icon(Icons.password_sharp),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
