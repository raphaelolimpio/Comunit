import '../Config/model/Post_model.dart';
import '../Config/server/Api_service.dart';

class TermoService {
  static Future<List<TermoCompletoModel>> listarTermos({String? busca}) async {
    final endpoint = busca != null && busca.isNotEmpty 
        ? '/termos/?busca=$busca' 
        : '/termos/';
    
    final response = await ApiService.request<List<TermoCompletoModel>>(
      endpoint: endpoint,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List).map((e) => TermoCompletoModel.fromJson(e)).toList(),
    );
    return response.data ?? [];
  }

  static Future<TermoCompletoModel?> obterDetalhes(int termoId) async {
    final response = await ApiService.request<TermoCompletoModel>(
      endpoint: '/termos/$termoId',
      verb: HttpVerb.get,
      fromJson: (json) => TermoCompletoModel.fromJson(json),
    );
    return response.data;
  }

  static Future<bool> criarTermo(String titulo, String categoria) async {
    final response = await ApiService.request(
      endpoint: '/termos/',
      verb: HttpVerb.post,
      body: {'titulo': titulo, 'categoria': categoria},
      fromJson: (json) => json,
    );
    return response.isSuccess;
  }

  static Future<bool> adicionarExplicacao(int termoId, String conteudo, String nivel) async {
    final response = await ApiService.request(
      endpoint: '/termos/$termoId/explicacoes/',
      verb: HttpVerb.post,
      body: {'conteudo': conteudo, 'nivel': nivel},
      fromJson: (json) => json,
    );
    return response.isSuccess;
  }

  static Future<bool> likeExplicacao(int explicacaoId) async {
    final response = await ApiService.request(
      endpoint: '/explicacoes/$explicacaoId/like',
      verb: HttpVerb.post,
      fromJson: (json) => json,
    );
    return response.isSuccess;
  }
}