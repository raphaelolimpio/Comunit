import 'package:flutter/material.dart';
import '../Config/model/Post_model.dart';
import '../Service/favorite_service.dart';
import '../DS/Components/Card/ListCard/List_card_custom.dart';
import '../shared/color.dart';

class FavorictWidget extends StatefulWidget {
  const FavorictWidget({super.key});

  @override
  State<FavorictWidget> createState() => _FavorictWidgetState();
}

class _FavorictWidgetState extends State<FavorictWidget> {
  late Future<List<TermoCompletoModel>> _favoritosFuture;

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  void _carregarFavoritos({bool forceRefresh = false}) {
    setState(() {
      _favoritosFuture = FavoriteService.getMeusFavoritos(forceRefresh: forceRefresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.5,
        title: const Text('Meus Favoritos', style: TextStyle(fontWeight: FontWeight.bold, color: BlackTextColor)),
      ),
      body: FutureBuilder<List<TermoCompletoModel>>(
        future: _favoritosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final favoritos = snapshot.data ?? [];

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () async => _carregarFavoritos(forceRefresh: true),
            child: ListCard(
              items: favoritos,
              displayMode: CardDisplayMode.verticalList,
              isFavoritedChecker: (_) => true,
              onFavoriteItem: (item) async {
                final termo = item as TermoCompletoModel;
                await FavoriteService.toggleFavorito(tipo: 'termo', itemId: termo.id);
                _carregarFavoritos(forceRefresh: true);
              },
            ),
          );
        },
      ),
    );
  }
}