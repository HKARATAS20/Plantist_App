import 'package:flutter/material.dart';

Container firebaseUIButton(
  BuildContext context,
  String title,
  IconData? icon,
  Color backgroundColor,
  Color textColor, {
  void Function() onTap = _defaultOnTap,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 80,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        surfaceTintColor: MaterialStateProperty.all<Color>(Colors.white),
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
                color: textColor, fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
    ),
  );
}

void _defaultOnTap() {}
