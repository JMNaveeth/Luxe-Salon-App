import '../home page/selected_shop.dart' as shop_detail;

class FavoriteSalonEntry {
  final String name;
  final String imageUrl;
  final String distance;
  final double rating;
  final int reviewCount;
  final bool darkTheme;
  final List<shop_detail.SpaService> services;

  const FavoriteSalonEntry({
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.darkTheme,
    required this.services,
  });
}

class FavoriteSalonStore {
  static final Map<String, FavoriteSalonEntry> _favorites = {};

  static void setFavorite(FavoriteSalonEntry entry, bool isFavorite) {
    if (isFavorite) {
      _favorites[entry.name] = entry;
    } else {
      _favorites.remove(entry.name);
    }
  }

  static bool isFavorite(String salonName) => _favorites.containsKey(salonName);

  static List<FavoriteSalonEntry> get favorites => _favorites.values.toList();
}
