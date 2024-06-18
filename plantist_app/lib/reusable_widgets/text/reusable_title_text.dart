import 'package:flutter/material.dart';

class ReusableTitleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ReusableTitleText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          // ignore: prefer_const_constructors
          TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
