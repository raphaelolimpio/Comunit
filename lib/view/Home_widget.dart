import 'package:flutter/material.dart';
import '../Config/model/Post_model.dart';
import '../Service/termo_service.dart';
import '../Service/favorite_service.dart';
import '../DS/Components/Card/ListCard/List_card_custom.dart';
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.5,
        title: const Text('Dicionário Dev', style: TextStyle(fontWeight: FontWeight.bold, color: BlackTextColor)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: primaryColor),
            onPressed: () => _carregarDados(forceRefresh: true),
          ),
        ],
      ),
      body: FutureBuilder<List<TermoCompletoModel>>(
        future: _termosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar feed: ${snapshot.error}'));
          }

          final termos = snapshot.data ?? [];

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () async => _carregarDados(forceRefresh: true),
            child: ListCard(
              items: termos,
              displayMode: CardDisplayMode.verticalList,
              isFavoritedChecker: (item) => _favoritosIds.contains((item as TermoCompletoModel).id),
              onFavoriteItem: (item) async {
                final termo = item as TermoCompletoModel;
                await FavoriteService.toggleFavorito(tipo: 'termo', itemId: termo.id);
                _carregarFavoritos();
              },
              onLikeItem: (item) async {
                final termo = item as TermoCompletoModel;
                if (termo.explicacoes.isNotEmpty) {
                  await TermoService.likeExplicacao(termo.explicacoes.first.id, termo.id);
                  _carregarDados(forceRefresh: true);
                }
              },
              onTapItem: (item) {
                // Ação de clique no card unificada
              },
            ),
          );
        },
      ),
    );
  }
}