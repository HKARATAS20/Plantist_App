import 'package:get/get.dart';

class PasswordController extends GetxController {
  var obscureText = true.obs;

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }
}
