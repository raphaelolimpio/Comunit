import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class MessageModel {
  final String text;
  final bool isMe;
  final String time;

  MessageModel({required this.text, required this.isMe, required this.time});
}

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String? contactAvatar;

  const ChatScreen({
    Key? key,
    required this.contactName,
    this.contactAvatar,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  // Lista de mensagens simuladas para iniciar a conversa
  final List<MessageModel> _messages = [
    MessageModel(text: 'Fala aí! Vi seu post sobre Provider no Flutter.', isMe: false, time: '14:10'),
    MessageModel(text: 'E aí! Curtiu? Deu um trabalhinho para estruturar o estado.', isMe: true, time: '14:12'),
    MessageModel(text: 'Sim, ficou muito limpo. Me tira uma dúvida rápida sobre o build context?', isMe: false, time: '14:15'),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        MessageModel(
          text: _messageController.text.trim(),
          isMe: true,
          time: TimeOfDay.now().format(context),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: techBackground,
      appBar: AppBar(
        backgroundColor: techSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: techTextWhite),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: techPrimary,
              backgroundImage: widget.contactAvatar != null ? NetworkImage(widget.contactAvatar!) : null,
              child: widget.contactAvatar == null
                  ? Text(
                      widget.contactName.isNotEmpty ? widget.contactName[0].toUpperCase() : 'C',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(color: techTextWhite, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Online',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ==========================================
          // LISTA DE MENSAGENS (BALÕES)
          // ==========================================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: msg.isMe ? techPrimary : techSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: msg.isMe ? null : Border.all(color: techBorderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: const TextStyle(color: techTextWhite, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg.time,
                            style: TextStyle(
                              color: msg.isMe ? Colors.white70 : techTextGray,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // BARRA INFERIOR DE ENVIO DE MENSAGEM
          // ==========================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: techSurface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: techTextWhite),
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      hintStyle: const TextStyle(color: techTextGray),
                      filled: true,
                      fillColor: techBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: techBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: techBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: techPrimary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: techPrimary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}