import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

Container colorChangingButton({
  required BuildContext context,
  required String title,
  IconData? icon,
  required Color backgroundColor,
  required Color textColor,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  VoidCallback? onPressed,
}) {
  final AuthController authController = Get.find();

  return Container(
    width: MediaQuery.of(context).size.width,
    height: 80,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton(
      onPressed: authController.isButtonEnabled.value ? onPressed : null,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(
          authController.isButtonEnabled.value ? backgroundColor : Colors.grey,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: textColor),
          if (icon != null) const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
