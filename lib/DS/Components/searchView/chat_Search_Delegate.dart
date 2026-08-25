import 'package:dicionario/Config/model/chat_model.dart';
import 'package:flutter/material.dart';

class ChatSearchDelegate extends SearchDelegate {
  final List<ChatItem> allChats;

  ChatSearchDelegate({required this.allChats});

  @override
  String get searchFieldLabel => 'Pesquisar pessoas ou grupos...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = allChats.where((chat) {
      return chat.name.toLowerCase().contains(query.toLowerCase()) ||
          chat.lastMessage.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text('Nenhum resultado encontrado'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        final isGroup = chat.type == ChatType.group;

        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(chat.avatarUrl),
              ),
              if (isGroup)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.group, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
          title: Text(chat.name),
          subtitle: Text(
            isGroup ? 'Grupo • ${chat.lastMessage}' : chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            isGroup ? 'Grupo' : 'Contato',
            style: TextStyle(
              fontSize: 11,
              color: isGroup ? Colors.blue : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // Ação ao selecionar um resultado de busca
            close(context, null);
            // Navegar para a conversa selecionada
          },
        );
      },
    );
  }
}