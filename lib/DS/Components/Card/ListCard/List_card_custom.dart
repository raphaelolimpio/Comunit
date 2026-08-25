import 'package:dicionario/DS/Components/Card/model/Code_snippet_card/code_snippet_card.dart';
import 'package:dicionario/DS/Components/Card/model/Dicionary_term_Card/dictionary_term_card.dart';
import 'package:flutter/material.dart';
import '../../../../Config/model/Post_model.dart'; // Onde estão seus models


enum CardDisplayMode { verticalList, horizontalScroll }

class ListCard extends StatelessWidget {
  final List<dynamic> items; // Pode receber List<TermoCompletoModel> ou List<SnippetModel>
  final CardDisplayMode displayMode;
  final double? listHeight;
  final ScrollController? controller;
  
  // Callbacks de Ação Social e Navegação
  final void Function(dynamic item)? onTapItem;
  final void Function(dynamic item)? onLikeItem;
  final void Function(dynamic item)? onCommentItem;
  final void Function(dynamic item)? onShareItem;
  final void Function(dynamic item)? onFavoriteItem;
  final bool Function(dynamic item)? isLikedChecker;
  final bool Function(dynamic item)? isFavoritedChecker;

  const ListCard({
    super.key,
    required this.items,
    this.displayMode = CardDisplayMode.verticalList,
    this.listHeight,
    this.controller,
    this.onTapItem,
    this.onLikeItem,
    this.onCommentItem,
    this.onShareItem,
    this.onFavoriteItem,
    this.isLikedChecker,
    this.isFavoritedChecker,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double responsiveCardWidth = screenWidth * 0.82;

    Widget buildItemWidget(BuildContext context, dynamic item, int index) {
      // Identifica se o item é um Termo ou um Snippet e renderiza o card correto
      Widget cardWidget;

      if (item is TermoCompletoModel) {
        cardWidget = DictionaryTermCard(
          termo: item,
          authorName: item.explicacoes.isNotEmpty ? item.explicacoes.first.autorNome : 'Dev Anônimo',
          authorAvatarUrl: item.explicacoes.isNotEmpty ? item.explicacoes.first.autorFoto : null,
          timeAgo: 'Recente', // Você pode formatar com base no model se preferir
          isLiked: isLikedChecker?.call(item) ?? false,
          isFavorited: isFavoritedChecker?.call(item) ?? false,
          likeCount: item.explicacoes.isNotEmpty ? item.explicacoes.first.upvotes : 0,
          onLike: () => onLikeItem?.call(item),
          onComment: () => onCommentItem?.call(item),
          onShare: () => onShareItem?.call(item),
          onFavorite: () => onFavoriteItem?.call(item),
          onTap: () => onTapItem?.call(item),
        );
      } else if (item is SnippetModel) {
        cardWidget = CodeSnippetCard(
          snippet: item,
          authorAvatarUrl: null, // Caso tenha foto no snippet model futuro
          timeAgo: 'Recente',
          isLiked: isLikedChecker?.call(item) ?? false,
          isFavorited: isFavoritedChecker?.call(item) ?? false,
          likeCount: item.upvotes,
          onLike: () => onLikeItem?.call(item),
          onComment: () => onCommentItem?.call(item),
          onShare: () => onShareItem?.call(item),
          onFavorite: () => onFavoriteItem?.call(item),
          onTap: () => onTapItem?.call(item),
        );
      } else {
        cardWidget = const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Tipo de item desconhecido na listagem.'),
        );
      }

      // Se for horizontal, envolvemos no tamanho responsivo
      if (displayMode == CardDisplayMode.horizontalScroll) {
        return SizedBox(
          width: responsiveCardWidth,
          child: cardWidget,
        );
      }

      return cardWidget;
    }

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Nenhum item encontrado por aqui.'),
        ),
      );
    }

    if (displayMode == CardDisplayMode.verticalList) {
      return ListView.builder(
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return buildItemWidget(context, items[index], index);
        },
      );
    } else {
      return SizedBox(
        height: listHeight ?? 380,
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: buildItemWidget(context, items[index], index),
            );
          },
        ),
      );
    }
  }
}