import 'package:flutter/material.dart';

class AppLayoutConfig {
  AppLayoutConfig._();

  static const double cardBorderRadius = 16.0;
  static const double cardElevation = 0.5;
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(vertical: 12);
  
  static BorderRadius get borderRadius => BorderRadius.circular(cardBorderRadius);
  
  static ShapeBorder get cardShape => RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      );
}