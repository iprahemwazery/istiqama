import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AzkarLocalService {
  static const _completedCountKey = 'completed_today_count';
  static const _completedIdsKey = 'completed_today_ids';
  static const _favoriteIdsKey = 'favorite_azkar_ids';

  Future<int> loadCompletedCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_completedCountKey) ?? 0;
  }

  Future<void> saveCompletedCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_completedCountKey, count);
  }

  Future<Set<int>> loadCompletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_completedIdsKey);
    if (raw == null) return {};
    final list = json.decode(raw) as List<dynamic>;
    return list.map((e) => e as int).toSet();
  }

  Future<void> saveCompletedIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_completedIdsKey, json.encode(ids.toList()));
  }

  Future<Set<int>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_favoriteIdsKey);
    if (raw == null) return {};
    final list = json.decode(raw) as List<dynamic>;
    return list.map((e) => e as int).toSet();
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoriteIdsKey, json.encode(ids.toList()));
  }
}
