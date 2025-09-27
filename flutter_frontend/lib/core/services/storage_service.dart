import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Auth Token
  Future<void> saveAuthToken(String token) async {
    print('StorageService: Saving auth token: ${token.substring(0, 20)}...');
    await _prefs.setString('auth_token', token);
    print('StorageService: Auth token saved successfully');
  }

  Future<String?> getAuthToken() async {
    final token = _prefs.getString('auth_token');
    print('StorageService: Retrieved auth token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
    return token;
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove('auth_token');
  }

  // User Data
  Future<void> saveUser(UserModel user) async {
    print('StorageService: Saving user: ${user.email}');
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString('current_user', userJson);
    print('StorageService: User saved successfully');
  }

  Future<UserModel?> getUser() async {
    final userJson = _prefs.getString('current_user');
    print('StorageService: Retrieved user JSON: ${userJson != null ? 'exists' : 'null'}');
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        print('StorageService: Parsed user: ${user.email}');
        return user;
      } catch (e) {
        print('StorageService: Error parsing user JSON: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove('current_user');
  }

  // App Settings
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString('theme_mode', themeMode);
  }

  Future<String?> getThemeMode() async {
    return _prefs.getString('theme_mode');
  }

  Future<void> saveLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  Future<String?> getLanguage() async {
    return _prefs.getString('language');
  }

  // Search History
  Future<void> saveSearchHistory(List<String> searches) async {
    await _prefs.setStringList('search_history', searches);
  }

  Future<List<String>> getSearchHistory() async {
    return _prefs.getStringList('search_history') ?? [];
  }

  Future<void> addToSearchHistory(String search) async {
    final history = await getSearchHistory();
    history.remove(search); // Remove if exists
    history.insert(0, search); // Add to beginning
    if (history.length > 10) {
      history.removeLast(); // Keep only last 10
    }
    await saveSearchHistory(history);
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove('search_history');
  }

  // Saved Properties
  Future<void> savePropertyIds(List<int> propertyIds) async {
    final ids = propertyIds.map((id) => id.toString()).toList();
    await _prefs.setStringList('saved_properties', ids);
  }

  Future<List<int>> getSavedPropertyIds() async {
    final ids = _prefs.getStringList('saved_properties') ?? [];
    return ids
        .map((id) => int.tryParse(id))
        .where((id) => id != null)
        .cast<int>()
        .toList();
  }

  Future<void> addSavedProperty(int propertyId) async {
    final saved = await getSavedPropertyIds();
    if (!saved.contains(propertyId)) {
      saved.add(propertyId);
      await savePropertyIds(saved);
    }
  }

  Future<void> removeSavedProperty(int propertyId) async {
    final saved = await getSavedPropertyIds();
    saved.remove(propertyId);
    await savePropertyIds(saved);
  }

  Future<bool> isPropertySaved(int propertyId) async {
    final saved = await getSavedPropertyIds();
    return saved.contains(propertyId);
  }

  // Filter Preferences
  Future<void> saveFilterPreferences(Map<String, dynamic> filters) async {
    final filterJson = jsonEncode(filters);
    await _prefs.setString('filter_preferences', filterJson);
  }

  Future<Map<String, dynamic>?> getFilterPreferences() async {
    final filterJson = _prefs.getString('filter_preferences');
    if (filterJson != null) {
      return jsonDecode(filterJson) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearFilterPreferences() async {
    await _prefs.remove('filter_preferences');
  }

  // Notification Settings
  Future<void> saveNotificationSettings(Map<String, bool> settings) async {
    final settingsJson = jsonEncode(settings);
    await _prefs.setString('notification_settings', settingsJson);
  }

  Future<Map<String, bool>> getNotificationSettings() async {
    final settingsJson = _prefs.getString('notification_settings');
    if (settingsJson != null) {
      final settings = jsonDecode(settingsJson) as Map<String, dynamic>;
      return settings.map((key, value) => MapEntry(key, value as bool));
    }
    return {
      'new_properties': true,
      'price_drops': true,
      'new_messages': true,
      'property_updates': true,
    };
  }

  // Clear All Data
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden');
});
