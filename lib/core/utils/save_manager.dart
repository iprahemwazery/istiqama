import 'package:shared_preferences/shared_preferences.dart';

class SaveManager {
  static const _lastPageKey = 'lastPage';
  static const _lastSuraNameKey = 'lastSuraName';

  static Future<void> saveLastPage(int page, String suraName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPageKey, page);
    await prefs.setString(_lastSuraNameKey, suraName);
  }

  static Future<int> getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastPageKey) ?? 1;
  }

  static Future<String> getLastSuraName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSuraNameKey) ?? '';
  }
}
