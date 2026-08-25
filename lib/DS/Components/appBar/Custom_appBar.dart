import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Substitui o título/nome do app pelo botão Criar
      title: PopupMenuButton<String>(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("Criar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        onSelected: (value) {
          if (value == 'termo') {
            // Rota para criar termo
          } else if (value == 'codigo') {
            // Rota para criar código explicativo
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'termo',
            child: Text('📝 Novo Termo'),
          ),
          const PopupMenuItem<String>(
            value: 'codigo',
            child: Text('💻 Código Explicativo'),
          ),
        ],
      ),
      actions: [
        // Substitui o antigo botão Criar pelo Chat
        IconButton(
          icon: Icon(Icons.chat_bubble_outline),
          onPressed: () {
            // Rota para a tela de Chat
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}