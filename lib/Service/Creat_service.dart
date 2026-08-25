import '../Config/cache/cache_termos/cache_termos.dart';
import '../Config/server/Api_service.dart';

class CreateService {
  static final _cache = MemoryCacheService();

  static Future<bool> criarSnippet({
    int? termoId,
    required String titulo,
    required String linguagem,
    required String codigo,
    required String explicacao,
  }) async {
    final response = await ApiService.request(
      endpoint: '/snippets/',
      verb: HttpVerb.post,
      body: {
        if (termoId != null) 'termo_id': termoId,
        'titulo': titulo,
        'linguagem': linguagem,
        'codigo': codigo,
        'explicacao': explicacao,
      },
      fromJson: (json) => json,
    );

    if (response.isSuccess) {
      if (termoId != null) {
        _cache.invalidate('termo_detalhe_$termoId');
      }
      _cache.invalidatePrefix('termos_');
    }
    return response.isSuccess;
  }
}