import 'package:shared_preferences/shared_preferences.dart';

class SaveManager {
  static const _lastPageKey = 'lastPage';
  static const _lastSuraNameKey = 'lastSuraName';
  static const _latitudeKey = 'savedLatitude';
  static const _longitudeKey = 'savedLongitude';
  static const _locationSavedKey = 'locationSaved';

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

  static Future<void> saveLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latitudeKey, latitude);
    await prefs.setDouble(_longitudeKey, longitude);
    await prefs.setBool(_locationSavedKey, true);
  }

  static Future<bool> hasSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationSavedKey) ?? false;
  }

  static Future<double?> getSavedLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_latitudeKey);
  }

  static Future<double?> getSavedLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_longitudeKey);
  }

  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_latitudeKey);
    await prefs.remove(_longitudeKey);
    await prefs.setBool(_locationSavedKey, false);
  }
}
