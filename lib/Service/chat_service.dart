import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Config/server/Api_service.dart';

class ChatService {
  WebSocketChannel? _channel;

  Future<void> conectarAoChat({
    required int conversaId,
    required Function(Map<String, dynamic>) onMensagemRecebida,
  }) async {
    final token = await ApiService.getToken();
    final host = ApiService.baseUrl.replaceAll('http://', 'ws://').replaceAll('https://', 'wss://');
    final uri = Uri.parse('$host/ws/chat/$conversaId?token=$token');

    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message);
      onMensagemRecebida(data);
    });
  }

  void enviarMensagem(String texto) {
    if (_channel != null && texto.trim().isNotEmpty) {
      _channel!.sink.add(jsonEncode({'conteudo': texto.trim()}));
    }
  }

  void desconectar() {
    _channel?.sink.close();
    _channel = null;
  }
}