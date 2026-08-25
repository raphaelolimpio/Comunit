import '../Config/cache/cache_termos/cache_termos.dart';
import '../Config/model/Post_model.dart';
import '../Config/server/Api_service.dart';

class TopicoModel {
  final String nome;
  final int totalTermos;

  TopicoModel({required this.nome, required this.totalTermos});

  factory TopicoModel.fromJson(Map<String, dynamic> json) {
    return TopicoModel(
      nome: json['nome'] ?? json['categoria'] ?? '',
      totalTermos: json['total_termos'] ?? json['quantidade'] ?? 0,
    );
  }
}

class TopicoService {
  static final _cache = MemoryCacheService();

  // 1. Listar todas as categorias/assuntos disponíveis (ex: Git, Flutter, Docker)
  static Future<List<TopicoModel>> listarTopicos({bool forceRefresh = false}) async {
    const cacheKey = 'topicos_lista';

    if (!forceRefresh) {
      final cached = _cache.get<List<TopicoModel>>(cacheKey);
      if (cached != null) return cached;
    }

    final response = await ApiService.request<List<TopicoModel>>(
      endpoint: '/termos/topicos',
      verb: HttpVerb.get,
      fromJson: (json) => (json as List).map((e) => TopicoModel.fromJson(e)).toList(),
    );

    if (response.isSuccess && response.data != null) {
      _cache.set(cacheKey, response.data!, duration: const Duration(minutes: 10));
      return response.data!;
    }
    return [];
  }

  // 2. Trazer todos os termos vinculados a um tópico específico (ex: tópico 'git' -> 'commit', 'rebase', 'merge')
  static Future<List<TermoCompletoModel>> obterTermosPorTopico(String topico, {bool forceRefresh = false}) async {
    final cacheKey = 'termos_topico_${topico.toLowerCase()}';

    if (!forceRefresh) {
      final cached = _cache.get<List<TermoCompletoModel>>(cacheKey);
      if (cached != null) return cached;
    }

    final response = await ApiService.request<List<TermoCompletoModel>>(
      endpoint: '/termos/?categoria=$topico',
      verb: HttpVerb.get,
      fromJson: (json) => (json as List).map((e) => TermoCompletoModel.fromJson(e)).toList(),
    );

    if (response.isSuccess && response.data != null) {
      _cache.set(cacheKey, response.data!, duration: const Duration(minutes: 5));
      return response.data!;
    }
    return [];
  }
}