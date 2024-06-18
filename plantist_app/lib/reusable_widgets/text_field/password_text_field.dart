import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final double scrollPadding;
  final void Function(String)? onChanged;

  PasswordField({
    required this.placeholder,
    required this.controller,
    this.scrollPadding = 20.0,
    this.onChanged,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.transparent,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
