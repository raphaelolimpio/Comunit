import 'package:flutter/material.dart';
import 'dart:math';

class NotificationAnimatedButton extends StatefulWidget {
  final List<String> unreadEmojis; // ex: ['❤️', '💬', '➕']

  const NotificationAnimatedButton({Key? key, required this.unreadEmojis}) : super(key: key);

  @override
  _NotificationAnimatedButtonState createState() => _NotificationAnimatedButtonState();
}

class _NotificationAnimatedButtonState extends State<NotificationAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // Faz a animação rodar em loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNotificationList() {
    // Aqui você abre o modal em lista
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text("Notificações", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(),
            ListTile(leading: Text('❤️'), title: Text('João curtiu seu termo')),
            ListTile(leading: Text('💬'), title: Text('Maria comentou no código')),
            ListTile(leading: Text('➕'), title: Text('Carlos solicitou conexão')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasNotifications = widget.unreadEmojis.isNotEmpty;

    return GestureDetector(
      onTap: _showNotificationList,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Botão central
          Icon(Icons.favorite_border, size: 30, color: Colors.black87),
          
          // Emojis Circulando
          if (hasNotifications)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(widget.unreadEmojis.length, (index) {
                    // Calcula o ângulo e o raio da órbita
                    final double angle = (_controller.value * 2 * pi) + (index * (2 * pi / widget.unreadEmojis.length));
                    final double radius = 22.0; // Distância do centro
                    
                    return Transform.translate(
                      offset: Offset(radius * cos(angle), radius * sin(angle)),
                      child: Text(widget.unreadEmojis[index], style: TextStyle(fontSize: 12)),
                    );
                  }),
                );
              },
            ),
        ],
      ),
    );
  }
}