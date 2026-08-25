import 'package:dicionario/Config/model/Post_model.dart';
import 'package:dicionario/DS/Components/Card/BaseCard/base_card_wrapper.dart';
import 'package:flutter/material.dart';


class DictionaryTermCard extends StatelessWidget {
  final TermoCompletoModel termo;
  final String authorName;
  final String? authorAvatarUrl;
  final String timeAgo;
  final bool isLiked;
  final bool isFavorited;
  final int likeCount;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const DictionaryTermCard({
    super.key,
    required this.termo,
    required this.authorName,
    this.authorAvatarUrl,
    required this.timeAgo,
    this.isLiked = false,
    this.isFavorited = false,
    this.likeCount = 0,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final String primeiraExplicacao = termo.explicacoes.isNotEmpty
        ? termo.explicacoes.first.conteudo
        : 'Nenhuma explicação cadastrada para este termo ainda.';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: BaseCardWrapper(
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        authorRole: termo.categoria, // Exibe a categoria no subtítulo do autor
        timeAgo: timeAgo,
        isLiked: isLiked,
        isFavorited: isFavorited,
        likeCount: likeCount,
        commentCount: termo.explicacoes.length,
        onLike: onLike,
        onComment: onComment,
        onShare: onShare,
        onFavorite: onFavorite,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge da Categoria / Tópico
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                termo.categoria.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Título do Termo do Dicionário
            Text(
              termo.titulo,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            
            // Prévia da Definição/Explicação
            Text(
              primeiraExplicacao,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Métricas Rápidas do Termo (Visões e Snippets disponíveis)
            Row(
              children: [
                _buildMetric(context, Icons.forum_outlined, '${termo.explicacoes.length} explicações'),
                const SizedBox(width: 16),
                _buildMetric(context, Icons.code_rounded, '${termo.snippets.length} snippets'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: theme.hintColor),
        ),
      ],
    );
  }
}