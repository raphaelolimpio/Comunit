class CacheEntry<T> {
  final T data;
  final DateTime expiresAt;

  CacheEntry({required this.data, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class MemoryCacheService {
  static final MemoryCacheService _instance = MemoryCacheService._internal();
  factory MemoryCacheService() => _instance;
  MemoryCacheService._internal();

  final Map<String, CacheEntry<dynamic>> _cache = {};

  void set<T>(String key, T data, {Duration duration = const Duration(minutes: 5)}) {
    _cache[key] = CacheEntry<T>(
      data: data,
      expiresAt: DateTime.now().add(duration),
    );
  }

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.data as T?;
  }

  void invalidate(String key) {
    _cache.remove(key);
  }

  void invalidatePrefix(String prefix) {
    _cache.removeWhere((key, _) => key.startsWith(prefix));
  }

  void clear() {
    _cache.clear();
  }
}