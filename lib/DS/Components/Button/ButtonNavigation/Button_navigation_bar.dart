import 'package:flutter/material.dart';
import 'package:dicionario/shared/color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: techSurface,
        border: Border(
          top: BorderSide(color: techBorderColor, width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabSelected,
        backgroundColor: Colors.transparent,
        indicatorColor: techPrimary.withOpacity(0.2), // Brilho neon suave ao selecionar
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_filled, color: techTextGray),
            selectedIcon: Icon(Icons.home_filled, color: techPrimary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: techTextGray),
            selectedIcon: Icon(Icons.search, color: techPrimary),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: techTextGray),
            selectedIcon: Icon(Icons.chat_bubble, color: techPrimary),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: techTextGray),
            selectedIcon: Icon(Icons.person, color: techPrimary),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}