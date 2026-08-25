import 'package:dicionario/DS/Components/Button/ButtonNavigation/Button_navigation_bar.dart';
import 'package:dicionario/DS/page/ProfilePage.dart';
import 'package:dicionario/DS/page/chat_home_screen.dart';
import 'package:dicionario/Service/termo_service.dart';
import 'package:dicionario/shared/color.dart';
import 'package:dicionario/view/Home_widget.dart';
import 'package:dicionario/view/Termo_widget.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _currentIndex = 0;

  // Chaves para gerenciar a pilha de navegação de cada aba individualmente (Estilo Instagram)
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // 0: Home
    GlobalKey<NavigatorState>(), // 1: Termos / Explorar
    GlobalKey<NavigatorState>(), // 2: Chat
    GlobalKey<NavigatorState>(), // 3: Perfil
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TermoService.listarTermos();
      }
    });
  }

  // Comportamento estilo Instagram: Se tocar na aba atual, volta para a raiz da pilha
  void _onItemTapped(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // Constrói o navegador isolado para cada aba
  Widget _buildOffstageNavigator(int index) {
    Widget child;
    switch (index) {
      case 0:
        child = const HomeWidget();
        break;
      case 1:
        child = const TermoWidget();
        break;
      case 2:
        child = const ChatHomeScreen();
        break;
      case 3:
        child = const ProfilePage();
        break;
      default:
        child = const HomeWidget();
    }

    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentIndex]
            .currentState!
            .maybePop();

        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: techBackground,
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
        // Aqui entra a barra customizada com a paleta tech
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTabSelected: _onItemTapped,
        ),
      ),
    );
  }
}