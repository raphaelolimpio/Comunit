import 'dart:io';
import 'package:flutter/foundation.dart';

class AppApi {
  // Resolução dinâmica de host por ambiente
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000'; // Emulador Android
    return 'http://localhost:8000'; // iOS / Desktop
  }

  // Resolução do host para WebSockets (Chat)
  static String get wsUrl {
    final base = baseUrl;
    if (base.startsWith('https://')) {
      return base.replaceFirst('https://', 'wss://');
    }
    return base.replaceFirst('http://', 'ws://');
  }

  // Endpoints de Autenticação & Usuários
  static const String authGoogle = '/auth/google';
  static const String meuPerfil = '/usuarios/me';
  static const String fcmToken = '/usuarios/me/fcm-token';

  // Endpoints de Termos & Tópicos
  static const String termos = '/termos/';
  static const String topicos = '/termos/topicos';
  static String termoDetalhes(int id) => '/termos/$id';
  static String adicionarExplicacao(int termoId) => '/termos/$termoId/explicacoes/';
  static String likeExplicacao(int explicacaoId) => '/explicacoes/$explicacaoId/like';

  // Endpoints de Snippets
  static const String snippets = '/snippets/';
  static String likeSnippet(int snippetId) => '/snippets/$snippetId/like';

  // Endpoints de Comentários
  static const String comentarios = '/comentarios/';
  static String comentariosPorAlvo(String tipoAlvo, int alvoId) => '/comentarios/$tipoAlvo/$alvoId';

  // Endpoints de Favoritos
  static const String meusFavoritos = '/usuarios/me/favoritos';
  static String toggleFavorito(String tipo, int itemId) => '/favoritos/$tipo/$itemId';

  // Endpoints de Chat & Calls
  static const String grupos = '/grupos';
  static String entrarGrupo(int grupoId) => '/grupos/$grupoId/entrar';
  static String mensagensGrupo(int grupoId) => '/grupos/$grupoId/mensagens';
  static String chatDireto(int destinatarioId) => '/conversas/direta/$destinatarioId';
  static String wsChat(int conversaId, String token) => '$wsUrl/ws/chat/$conversaId?token=$token';
  static String callToken(int conversaId) => '/calls/token/$conversaId';
}