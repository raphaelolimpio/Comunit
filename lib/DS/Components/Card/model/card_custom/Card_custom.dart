import 'package:flutter/material.dart';
import '../../../../../Config/model/Post_model.dart';

class CardTermoCustom extends StatelessWidget {
  final TermoCompletoModel termo;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const CardTermoCustom({
    Key? key,
    required this.termo,
    required this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primeiraExplicacao = termo.explicacoes.isNotEmpty 
        ? termo.explicacoes.first.conteudo 
        : 'Nenhuma explicação adicionada ainda. Seja o primeiro dev a explicar!';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topo: Categoria + Botão Favorito
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    if (onFavoriteToggle != null)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isFavorite ? theme.primaryColor : Colors.grey,
                          size: 22,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Título do Termo
                Text(
                  termo.titulo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Preview da Explicação
                Text(
                  primeiraExplicacao,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),

                // Rodapé com Métricas (Explicações e Snippets)
                Row(
                  children: [
                    _buildMetricBadge(
                      context,
                      icon: Icons.forum_outlined,
                      label: '${termo.explicacoes.length} visões',
                    ),
                    const SizedBox(width: 14),
                    _buildMetricBadge(
                      context,
                      icon: Icons.code_rounded,
                      label: '${termo.snippets.length} snippets',
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: theme.hintColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadge(BuildContext context, {required IconData icon, required String label}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }
}