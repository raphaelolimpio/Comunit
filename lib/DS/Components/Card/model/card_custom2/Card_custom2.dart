import 'package:flutter/material.dart';
import '../../../../../Config/model/Post_model.dart';

class CardExplicacaoWidget extends StatelessWidget {
  final ExplicacaoModel explicacao;
  final VoidCallback onLike;

  const CardExplicacaoWidget({
    Key? key,
    required this.explicacao,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Autor e Nível (Iniciante, Pleno, Avançado)
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: explicacao.autorFoto != null 
                    ? NetworkImage(explicacao.autorFoto!) 
                    : null,
                child: explicacao.autorFoto == null 
                    ? Text(explicacao.autorNome[0].toUpperCase()) 
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    explicacao.autorNome,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    explicacao.nivel,
                    style: TextStyle(color: theme.primaryColor, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(),
              // Botão de Upvote / Curtir
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onLike,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, size: 14, color: theme.primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        '${explicacao.upvotes}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Texto da Explicação
          Text(
            explicacao.conteudo,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}