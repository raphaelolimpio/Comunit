import 'package:dicionario/Config/Api/Api.dart';

import '../Config/cache/cache_termos/cache_termos.dart';
import '../Config/model/Post_model.dart';
import '../Config/server/Api_service.dart';

class FavoriteService {
  static final _cache = MemoryCacheService();

  static Future<List<TermoCompletoModel>> getMeusFavoritos({bool forceRefresh = false}) async {
    const cacheKey = 'meus_favoritos';
    if (!forceRefresh) {
      final cached = _cache.get<List<TermoCompletoModel>>(cacheKey);
      if (cached != null) return cached;
    }

    final response = await ApiService.request<List<TermoCompletoModel>>(
      endpoint: AppApi.meusFavoritos,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List).map((e) => TermoCompletoModel.fromJson(e)).toList(),
    );

    if (response.isSuccess && response.data != null) {
      _cache.set(cacheKey, response.data!, duration: const Duration(minutes: 5));
      return response.data!;
    }
    return [];
  }

  static Future<bool> toggleFavorito({required String tipo, required int itemId}) async {
    final response = await ApiService.request(
      endpoint: AppApi.toggleFavorito(tipo, itemId),
      verb: HttpVerb.post,
      fromJson: (json) => json,
    );
    if (response.isSuccess) {
      _cache.invalidate('meus_favoritos');
    }
    return response.isSuccess;
  }
}