import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/email_validation_controller.dart';

class EmailField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final double scrollPadding;
  final void Function(String)? onChanged;

  EmailField({
    required this.placeholder,
    required this.controller,
    this.scrollPadding = 20.0,
    this.onChanged,
  });

  final EmailValidationController _emailValidationController =
      Get.put(EmailValidationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextField(
        controller: controller,
        onChanged: (value) {
          _emailValidationController.validateEmail(value);
          onChanged?.call(value);
        },
        cursorColor: Colors.grey,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: placeholder,
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
          suffixIcon: _emailValidationController.isValid.value
              ? const Icon(Icons.check, color: Colors.green)
              : null,
        ),
        keyboardType: TextInputType.emailAddress,
      );
    });
  }
}
