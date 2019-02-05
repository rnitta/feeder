import 'package:flutter/material.dart';

class PaddingText {
  static Padding build(
      String text, double left, double top, double right, double bottom) {
    return Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: Text(text));
  }
}
