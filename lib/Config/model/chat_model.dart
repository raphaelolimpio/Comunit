enum ChatType { individual, group }

class ChatItem {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final ChatType type;

  ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    required this.type,
  });
}

class CallItem {
  final String name;
  final String time;
  final String avatarUrl;
  final bool isVideoCall;
  final bool isMissed;
  final bool isOutgoing;

  CallItem({
    required this.name,
    required this.time,
    required this.avatarUrl,
    required this.isVideoCall,
    required this.isMissed,
    required this.isOutgoing,
  });
}