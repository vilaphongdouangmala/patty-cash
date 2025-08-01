import 'package:flutter/material.dart';

extension ContextSize on BuildContext {
  double contextWidth() {
    return MediaQuery.of(this).size.width;
  }

  double contextHeight() {
    return MediaQuery.of(this).size.height;
  }

  static double responsiveText(BuildContext context,
      {required double textFontSize}) {
    final double fontSize =
        context.contextWidth() < 380 ? textFontSize - 2 : textFontSize;
    return fontSize;
  }

  bool isKeyboardVisible() {
    return MediaQuery.of(this).viewInsets.bottom > 0;
  }
}
