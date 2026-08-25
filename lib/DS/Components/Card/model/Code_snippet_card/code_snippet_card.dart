import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/base_card_wrapper.dart';
import 'package:dicionario/DS/Components/bash/code_block_widget.dart';
import 'package:flutter/material.dart';


class CodeSnippetCard extends StatelessWidget {
  final SnippetModel snippet;
  final String? authorAvatarUrl;
  final String timeAgo;
  final bool isLiked;
  final bool isFavorited;
  final int likeCount;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const CodeSnippetCard({
    super.key,
    required this.snippet,
    this.authorAvatarUrl,
    required this.timeAgo,
    this.isLiked = false,
    this.isFavorited = false,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: BaseCardWrapper(
        authorName: snippet.autorNome,
        authorAvatarUrl: authorAvatarUrl,
        authorRole: 'Snippet de Código',
        timeAgo: timeAgo,
        isLiked: isLiked,
        isFavorited: isFavorited,
        likeCount: likeCount,
        commentCount: commentCount,
        onLike: onLike,
        onComment: onComment,
        onShare: onShare,
        onFavorite: onFavorite,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do Snippet
            Text(
              snippet.titulo,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Explicação curta do que o código faz
            Text(
              snippet.explicacao,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),

            // O Bloco de Código Estilizado com Tema por Linguagem
            CodeBlockWidget(
              code: snippet.codigo,
              linguagem: snippet.linguagem,
            ),
          ],
        ),
      ),
    );
  }
}