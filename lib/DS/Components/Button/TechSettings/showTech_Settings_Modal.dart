import 'package:flutter/material.dart';
import 'package:dicionario/shared/color.dart'; // Ajuste o import se necessário

void showTechSettingsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: techSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '// CONFIG_SISTEMA',
                  style: TextStyle(
                    color: techPrimary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: techTextGray),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: techBorderColor),
            const SizedBox(height: 10),
            
            // Opção: Mudar Tema
            ListTile(
              leading: const Icon(Icons.terminal, color: techSecondary),
              title: const Text('Alternar Tema (Matrix/Cyber)', style: TextStyle(color: techTextWhite)),
              subtitle: const Text('Modo escuro avançado ativado', style: TextStyle(color: techTextGray, fontSize: 12)),
              onTap: () {
                // Lógica de alternar tema aqui
                Navigator.pop(context);
              },
            ),
            
            // Opção: Deslogar
            ListTile(
              leading: const Icon(Icons.power_settings_new, color: techRedAlert),
              title: const Text('Deslogar da Sessão', style: TextStyle(color: techRedAlert)),
              subtitle: const Text('Encerrar token de acesso atual', style: TextStyle(color: techTextGray, fontSize: 12)),
              onTap: () {
                // Lógica de logout aqui
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}