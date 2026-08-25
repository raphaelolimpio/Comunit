import 'package:dicionario/Service/termo_service.dart';
import 'package:dicionario/shared/color.dart';
import 'package:dicionario/view/Add_widget.dart';
import 'package:dicionario/view/Favorite_widget.dart';
import 'package:dicionario/view/Home_widget.dart';
import 'package:dicionario/view/Termo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _currentIndex = 0;

  // Chaves para gerenciar a pilha de navegação de cada aba individualmente (Estilo Instagram)
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Termos / Explorar
    GlobalKey<NavigatorState>(), // Criar (Add)
    GlobalKey<NavigatorState>(), // Favoritos
  ];

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      // Alterado de initialLoad() para listarTermos()
      context.read<TermoService>().listarTermos();
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
        child = const AddWidget();
        break;
      case 3:
        child = const FavorictWidget();
        break;
      default:
        child = const HomeWidget();
    }

    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        // Permite voltar nas telas internas da aba ativa antes de sair do app
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            // Se estiver em outra aba, volta para a Home (índice 0) em vez de fechar o app
            setState(() {
              _currentIndex = 0;
            });
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: iconInAtivoDark,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Criar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}