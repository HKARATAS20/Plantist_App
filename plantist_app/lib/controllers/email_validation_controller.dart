import 'package:get/get.dart';

class EmailValidationController extends GetxController {
  RxBool isValid = false.obs;

  void validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    isValid.value = emailRegex.hasMatch(email);
  }

  void resetState() {
    isValid.value = false;
  }
}
