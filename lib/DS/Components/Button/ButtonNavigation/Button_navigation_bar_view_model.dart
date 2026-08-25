import 'package:flutter/material.dart';

class ButtonNavigationBarViewModel {
  final String name;
  final IconData icon;
  final IconData selectedIcon;

  ButtonNavigationBarViewModel({
    required this.name,
    required this.icon,
    required this.selectedIcon,
  });
}