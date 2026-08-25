import 'package:dicionario/DS/Components/Button/Notification_Animated_Button/Notification_Animated_Button.dart';
import 'package:flutter/material.dart';
import '../Config/model/Post_model.dart';
import '../Service/termo_service.dart';
import '../Service/favorite_service.dart';
import '../DS/Components/Card/ListCard/List_card_custom.dart';
import '../view/Add_widget.dart';
import '../shared/color.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<List<TermoCompletoModel>> _termosFuture;
  final Set<int> _favoritosIds = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados({bool forceRefresh = false}) {
    setState(() {
      _termosFuture = TermoService.listarTermos(forceRefresh: forceRefresh);
    });
    _carregarFavoritos();
  }

  Future<void> _carregarFavoritos() async {
    final favs = await FavoriteService.getMeusFavoritos();
    if (mounted) {
      setState(() {
        _favoritosIds.clear();
        _favoritosIds.addAll(favs.map((e) => e.id));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        elevation: 0,
        // Botão de adicionar no canto esquerdo (seguindo o padrão da ProfilePage)[cite: 7]
        leading: IconButton(
          icon: const Icon(Icons.add_box_outlined, color: techTextWhite),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddWidget()),
            );
          },
        ),
        // Nome do app centralizado
        title: const Text(
          '// Dicionário_Dev',
          style: TextStyle(fontWeight: FontWeight.bold, color: techTextWhite, fontFamily: 'monospace'),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: NotificationAnimatedButton(
                unreadEmojis: ['❤️', '💬', '➕'],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<TermoCompletoModel>>(
        future: _termosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: techPrimary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar feed: ${snapshot.error}', style: const TextStyle(color: techTextWhite)),
            );
          }

          final termos = snapshot.data ?? [];

          return RefreshIndicator(
            color: techPrimary,
            backgroundColor: techSurface,
            onRefresh: () async => _carregarDados(forceRefresh: true),
            child: ListCard(
              items: termos,
              displayMode: CardDisplayMode.verticalList,
              isFavoritedChecker: (item) =>
                  _favoritosIds.contains((item as TermoCompletoModel).id),
              onFavoriteItem: (item) async {
                final termo = item as TermoCompletoModel;
                await FavoriteService.toggleFavorito(
                  tipo: 'termo',
                  itemId: termo.id,
                );
                _carregarFavoritos();
              },
              onLikeItem: (item) async {
                final termo = item as TermoCompletoModel;
                if (termo.explicacoes.isNotEmpty) {
                  await TermoService.likeExplicacao(
                    termo.explicacoes.first.id,
                    termo.id,
                  );
                  _carregarDados(forceRefresh: true);
                }
              },
              onTapItem: (item) {},
            ),
          );
        },
      ),
    );
  }
}