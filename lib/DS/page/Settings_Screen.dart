import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true; // Exemplo de estado visual do tema
  bool _notificationsEnabled = true;

  // Função para exibir o modal de confirmação de saída (Sair)
  void _mostrarConfirmacaoSair() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: techSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: techBorderColor),
        ),
        title: const Text(
          'Sair da Conta',
          style: TextStyle(color: techTextWhite, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tem certeza de que deseja encerrar a sua sessão atual?',
          style: TextStyle(color: techTextGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: techTextGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              
              // TODO: Insira aqui a limpeza do seu cache/token (ex: SharedPreferences / FirebaseAuth)
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão encerrada com sucesso.')),
              );
              
              // Exemplo de redirecionamento para o Login (descomente se tiver a rota)
              // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        elevation: 0,
        title: const Text(
          'Configurações',
          style: TextStyle(color: techTextWhite, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: techTextWhite),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ==========================================
          // SEÇÃO DE APARÊNCIA
          // ==========================================
          const Text(
            'APARÊNCIA',
            style: TextStyle(
              color: techPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: techSurface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: techBorderColor),
            ),
            child: SwitchListTile(
              title: const Text(
                'Modo Escuro / Tech',
                style: TextStyle(color: techTextWhite, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Alternar o padrão de cores da interface',
                style: TextStyle(color: techTextGray, fontSize: 12),
              ),
              value: _isDarkMode,
              activeColor: techPrimary,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                // TODO: Conecte aqui ao seu ThemeProvider ou Bloc de gerenciamento de tema
              },
            ),
          ),
          const SizedBox(height: 24),

          // ==========================================
          // SEÇÃO DE PREFERÊNCIAS
          // ==========================================
          const Text(
            'PREFERÊNCIAS',
            style: TextStyle(
              color: techPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: techSurface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: techBorderColor),
            ),
            child: SwitchListTile(
              title: const Text(
                'Notificações Push',
                style: TextStyle(color: techTextWhite, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Receber alertas de novas interações e posts',
                style: TextStyle(color: techTextGray, fontSize: 12),
              ),
              value: _notificationsEnabled,
              activeColor: techPrimary,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),

          // ==========================================
          // SEÇÃO DA CONTA
          // ==========================================
          const Text(
            'CONTA',
            style: TextStyle(
              color: techPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: techSurface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: techBorderColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Sair da Conta',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Encerrar a sessão atual neste dispositivo',
                style: TextStyle(color: techTextGray, fontSize: 12),
              ),
              onTap: _mostrarConfirmacaoSair,
            ),
          ),
        ],
      ),
    );
  }
}