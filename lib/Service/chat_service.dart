import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Config/Api/Api.dart';
import '../Config/server/Api_service.dart';

class MensagemModel {
  final int id;
  final int autorId;
  final String autorNome;
  final String conteudo;
  final DateTime criadoEm;

  MensagemModel({
    required this.id,
    required this.autorId,
    required this.autorNome,
    required this.conteudo,
    required this.criadoEm,
  });

  factory MensagemModel.fromJson(Map<String, dynamic> json) {
    return MensagemModel(
      id: json['id'] ?? 0,
      autorId: json['autor_id'] ?? json['usuario_id'] ?? 0,
      autorNome: json['autor_nome'] ?? json['nome'] ?? 'Dev',
      conteudo: json['conteudo'] ?? json['texto'] ?? '',
      criadoEm: DateTime.tryParse(json['criado_em'] ?? '') ?? DateTime.now(),
    );
  }
}

class ChatService {
  WebSocketChannel? _channel;

  // 1. Obter ou criar conversa direta com outro dev
  static Future<int?> abrirChatDireto(int destinatarioId) async {
    final response = await ApiService.request<Map<String, dynamic>>(
      endpoint: AppApi.chatDireto(destinatarioId),
      verb: HttpVerb.post,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return response.data?['conversa_id'] ?? response.data?['id'];
  }

  // 2. Buscar histórico de mensagens antigas da conversa
  static Future<List<MensagemModel>> obterHistoricoMensagens(int conversaId) async {
    final response = await ApiService.request<List<MensagemModel>>(
      endpoint: '/conversas/$conversaId/mensagens',
      verb: HttpVerb.get,
      fromJson: (json) => (json as List).map((m) => MensagemModel.fromJson(m)).toList(),
    );
    return response.data ?? [];
  }

  // 3. Conectar ao WebSocket para mensagens em tempo real
  Future<void> conectarAoChat({
    required int conversaId,
    required Function(MensagemModel) onMensagemRecebida,
  }) async {
    final token = await ApiService.getToken();
    final uri = Uri.parse(AppApi.wsChat(conversaId, token ?? ''));

    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message);
      onMensagemRecebida(MensagemModel.fromJson(data));
    });
  }

  // 4. Enviar mensagem pelo canal WebSocket
  void enviarMensagem(String texto) {
    if (_channel != null && texto.trim().isNotEmpty) {
      _channel!.sink.add(jsonEncode({'conteudo': texto.trim()}));
    }
  }

  // 5. Encerrar conexão do WebSocket
  void desconectar() {
    _channel?.sink.close();
    _channel = null;
  }
}