import 'package:dicionario/Config/model/chat_model.dart';
import 'package:dicionario/DS/Components/searchView/chat_Search_Delegate.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final List<ChatItem> _allChats = [
    ChatItem(
      id: '1',
      name: 'Ana Silva',
      lastMessage: 'Você viu o novo código?',
      time: '14:20',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      unreadCount: 2,
      type: ChatType.individual,
    ),
    ChatItem(
      id: '2',
      name: 'Devs Flutter Brasil',
      lastMessage: 'Carlos: Alguém já usou esse package?',
      time: '13:05',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      unreadCount: 5,
      type: ChatType.group,
    ),
    ChatItem(
      id: '3',
      name: 'Lucas Souza',
      lastMessage: 'Combinado então!',
      time: 'Ontem',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      unreadCount: 0,
      type: ChatType.individual,
    ),
    ChatItem(
      id: '4',
      name: 'Projeto Mobile UI/UX',
      lastMessage: 'Mariana: Enviei o layout atualizado.',
      time: 'Ontem',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      unreadCount: 0,
      type: ChatType.group,
    ),
  ];

  final List<CallItem> _calls = [
    CallItem(
      name: 'Ana Silva',
      time: 'Hoje, 11:30',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isVideoCall: true,
      isMissed: true,
      isOutgoing: false,
    ),
    CallItem(
      name: 'Lucas Souza',
      time: 'Ontem, 18:45',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      isVideoCall: false,
      isMissed: false,
      isOutgoing: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final individualChats = _allChats.where((c) => c.type == ChatType.individual).toList();
    final groupChats = _allChats.where((c) => c.type == ChatType.group).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: techBackground,
        appBar: AppBar(
          backgroundColor: techSurface,
          elevation: 0,
          title: const Text('Conversas', style: TextStyle(color: techTextWhite)),
          iconTheme: const IconThemeData(color: techTextWhite),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: techTextWhite),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ChatSearchDelegate(allChats: _allChats),
                );
              },
            ),
            PopupMenuButton<String>(
              color: techSurface,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'new_group', child: Text('Novo grupo', style: TextStyle(color: techTextWhite))),
                const PopupMenuItem(value: 'settings', child: Text('Configurações', style: TextStyle(color: techTextWhite))),
              ],
            ),
          ],
          bottom: const TabBar(
            indicatorColor: techPrimary,
            labelColor: techPrimary,
            unselectedLabelColor: techTextGray,
            tabs: [
              Tab(text: 'Conversas'),
              Tab(text: 'Grupos'),
              Tab(text: 'Ligações'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatList(individualChats),
            _buildChatList(groupChats),
            _buildCallsList(_calls),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: techPrimary,
          onPressed: () {},
          child: const Icon(Icons.message, color: techBackground),
        ),
      ),
    );
  }

  Widget _buildChatList(List<ChatItem> chats) {
    if (chats.isEmpty) {
      return const Center(child: Text('Nenhuma conversa encontrada', style: TextStyle(color: techTextGray)));
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 70, color: techBorderColor),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(chat.avatarUrl),
          ),
          title: Text(
            chat.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: techTextWhite),
          ),
          subtitle: Text(
            chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: techTextGray),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.time,
                style: TextStyle(
                  fontSize: 12,
                  color: chat.unreadCount > 0 ? techPrimary : techTextGray,
                ),
              ),
              const SizedBox(height: 4),
              if (chat.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: techPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat.unreadCount}',
                    style: const TextStyle(color: techBackground, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildCallsList(List<CallItem> calls) {
    if (calls.isEmpty) {
      return const Center(child: Text('Nenhuma ligação recente', style: TextStyle(color: techTextGray)));
    }

    return ListView.separated(
      itemCount: calls.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 70, color: techBorderColor),
      itemBuilder: (context, index) {
        final call = calls[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(call.avatarUrl),
          ),
          title: Text(
            call.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: call.isMissed ? techRedAlert : techTextWhite,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                call.isOutgoing ? Icons.call_made : Icons.call_received,
                size: 16,
                color: call.isMissed ? techRedAlert : techPrimary,
              ),
              const SizedBox(width: 4),
              Text(call.time, style: const TextStyle(color: techTextGray)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(call.isVideoCall ? Icons.videocam : Icons.call),
            color: techPrimary,
            onPressed: () {},
          ),
        );
      },
    );
  }
}