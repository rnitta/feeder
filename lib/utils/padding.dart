import 'package:flutter/material.dart';

class PaddingText extends Padding {
  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;
  PaddingText(this.text, this.left, this.top, this.right, this.bottom)
      : super(
            padding: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: Text(text));
}
