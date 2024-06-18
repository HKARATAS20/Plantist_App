// auth_controller.dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isButtonEnabled = false.obs;

  void updateButtonState(String email, String password) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final isEmailValid = emailRegex.hasMatch(email);
    final isPasswordValid = password.length >= 6;
    isButtonEnabled.value = isEmailValid && isPasswordValid;
  }
}
