
import 'package:shared_preferences/shared_preferences.dart';

class FavStorage {
  static const String key = "favorites";

  static Future<void> saveFavorites(Set<String> favs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, favs.toList());
  }

  static Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key)?.toSet() ?? {};
  }
}