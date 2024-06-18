import 'package:flutter/cupertino.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget trailing;
  final String? additionalInfo;
  final Widget? subtitle;

  const CustomListTile(
      {required this.title,
      required this.onTap,
      required this.trailing,
      this.additionalInfo,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 249, 250, 251),
            border: Border.all(color: CupertinoColors.separator),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CupertinoListTile(
            title: Text(title),
            trailing: trailing,
            additionalInfo: Text(
              additionalInfo ?? "",
              style: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            subtitle: subtitle ?? Container(),
          ),
        ),
      ),
    );
  }
}
