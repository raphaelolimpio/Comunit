import 'package:flutter/material.dart';

class PostCreationMenu {
  static void show(
    BuildContext context, {
    required VoidCallback onAddTermo,
    required VoidCallback onAddSnippet,
  }) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador visual superior (puxador)
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Título
                Text(
                  'Criar nova publicação',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha o formato do conteúdo que deseja compartilhar com a comunidade:',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),

                // Opção 1: Termo de Dicionário
                _buildMenuItem(
                  context,
                  icon: Icons.auto_stories_rounded,
                  iconColor: theme.primaryColor,
                  title: 'Termo de Dicionário',
                  subtitle: 'Adicione um novo conceito, definição e explicações técnicas.',
                  onTap: () {
                    Navigator.pop(context); // Fecha o menu
                    onAddTermo();         // Executa a ação de ir para tela de termo
                  },
                ),
                const Divider(height: 24),

                // Opção 2: Snippet de Código
                _buildMenuItem(
                  context,
                  icon: Icons.code_rounded,
                  iconColor: Colors.amber.shade700,
                  title: 'Snippet de Código',
                  subtitle: 'Compartilhe um bloco de código formatado com explicações.',
                  onTap: () {
                    Navigator.pop(context); // Fecha o menu
                    onAddSnippet();       // Executa a ação de ir para tela de snippet
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
