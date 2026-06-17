import 'package:flutter_test/flutter_test.dart';
import 'package:recipes/services/fav_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FavStorage', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveFavorites saves data correctly', () async {
      final favoritesToSave = {'123', '456'};
      
      await FavStorage.saveFavorites(favoritesToSave);
      
      final loadedFavorites = await FavStorage.loadFavorites();
      expect(loadedFavorites, containsAll(['123', '456']));
      expect(loadedFavorites.length, 2);
    });

    test('loadFavorites returns empty set when no data exists', () async {
      final loadedFavorites = await FavStorage.loadFavorites();
      
      expect(loadedFavorites, isEmpty);
    });

    test('saveFavorites overwrites previous data', () async {
      await FavStorage.saveFavorites({'111'});
      var loadedFavorites = await FavStorage.loadFavorites();
      expect(loadedFavorites, {'111'});
      
      await FavStorage.saveFavorites({'222', '333'});
      loadedFavorites = await FavStorage.loadFavorites();
      
      expect(loadedFavorites, {'222', '333'});
      expect(loadedFavorites.contains('111'), isFalse);
    });
  });
}
