import 'package:flutter/foundation.dart';

import '../models/anime.dart';
import 'dummy_data.dart';

class FavoriteStore extends ChangeNotifier {
  FavoriteStore._();

  static final FavoriteStore instance = FavoriteStore._();

  final Set<String> _favoriteIds = {};

  bool contains(String animeId) => _favoriteIds.contains(animeId);

  List<Anime> get favorites => DummyData.animeList
      .where((anime) => _favoriteIds.contains(anime.id))
      .toList(growable: false);

  void toggle(String animeId) {
    if (!_favoriteIds.add(animeId)) {
      _favoriteIds.remove(animeId);
    }
    notifyListeners();
  }
}
