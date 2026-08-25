import 'package:dicionario/Config/Api/Api.dart';

import '../Config/cache/cache_termos/cache_termos.dart';
import '../Config/model/Post_model.dart';
import '../Config/server/Api_service.dart';

class TermoService {
  static final _cache = MemoryCacheService();

  static Future<List<TermoCompletoModel>> listarTermos({String? busca, bool forceRefresh = false}) async {
    final cacheKey = 'termos_${busca ?? "todos"}';

    if (!forceRefresh) {
      final cached = _cache.get<List<TermoCompletoModel>>(cacheKey);
      if (cached != null) return cached;
    }

    final endpoint = (busca != null && busca.isNotEmpty) 
        ? '/termos/?busca=$busca' 
        : AppApi.termos;

    final response = await ApiService.request<List<TermoCompletoModel>>(
      endpoint: endpoint,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List).map((e) => TermoCompletoModel.fromJson(e)).toList(),
    );

    if (response.isSuccess && response.data != null) {
      _cache.set(cacheKey, response.data!, duration: const Duration(minutes: 5));
      return response.data!;
    }
    return [];
  }

  static Future<TermoCompletoModel?> obterDetalhes(int termoId, {bool forceRefresh = false}) async {
    final cacheKey = 'termo_detalhe_$termoId';

    if (!forceRefresh) {
      final cached = _cache.get<TermoCompletoModel>(cacheKey);
      if (cached != null) return cached;
    }

    final response = await ApiService.request<TermoCompletoModel>(
      endpoint: '/termos/$termoId',
      verb: HttpVerb.get,
      fromJson: (json) => TermoCompletoModel.fromJson(json),
    );

    if (response.isSuccess && response.data != null) {
      _cache.set(cacheKey, response.data!, duration: const Duration(minutes: 3));
      return response.data;
    }
    return null;
  }

  static Future<bool> criarTermo(String titulo, String categoria) async {
    final response = await ApiService.request(
      endpoint: AppApi.termos,
      verb: HttpVerb.post,
      body: {'titulo': titulo, 'categoria': categoria},
      fromJson: (json) => json,
    );
    if (response.isSuccess) {
      _cache.invalidatePrefix('termos_');
    }
    return response.isSuccess;
  }

  static Future<bool> adicionarExplicacao(int termoId, String conteudo, String nivel) async {
    final response = await ApiService.request(
      endpoint: AppApi.adicionarExplicacao(termoId),
      verb: HttpVerb.post,
      body: {'conteudo': conteudo, 'nivel': nivel},
      fromJson: (json) => json,
    );
    if (response.isSuccess) {
      _cache.invalidate('termo_detalhe_$termoId');
      _cache.invalidatePrefix('termos_');
    }
    return response.isSuccess;
  }

  static Future<bool> likeExplicacao(int explicacaoId, int termoId) async {
    final response = await ApiService.request(
      endpoint: AppApi.likeExplicacao(explicacaoId),
      verb: HttpVerb.post,
      fromJson: (json) => json,
    );
    if (response.isSuccess) {
      _cache.invalidate('termo_detalhe_$termoId');
    }
    return response.isSuccess;
  }
}