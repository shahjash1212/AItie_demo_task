// lib/utils/feature_flag_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class FeatureFlagService {
  static const String _favoritesKey = 'feature_favorites_enabled';
  static const String _cartKey = 'feature_cart_enabled';
  static const String _offlineCachingKey = 'feature_offline_caching_enabled';
  static const String _debugMenuKey = 'debug_menu_enabled';

  final SharedPreferences _prefs;

  FeatureFlagService(this._prefs);

  Future<void> initializeDefaults() async {
    if (!_prefs.containsKey(_favoritesKey)) {
      await _prefs.setBool(_favoritesKey, true);
    }
    if (!_prefs.containsKey(_cartKey)) {
      await _prefs.setBool(_cartKey, true);
    }
    if (!_prefs.containsKey(_offlineCachingKey)) {
      await _prefs.setBool(_offlineCachingKey, true);
    }
    if (!_prefs.containsKey(_debugMenuKey)) {
      await _prefs.setBool(_debugMenuKey, false);
    }
  }

  bool get isFavoritesEnabled => _prefs.getBool(_favoritesKey) ?? true;
  bool get isCartEnabled => _prefs.getBool(_cartKey) ?? true;
  bool get isOfflineCachingEnabled =>
      _prefs.getBool(_offlineCachingKey) ?? true;
  bool get isDebugMenuEnabled => _prefs.getBool(_debugMenuKey) ?? false;

  Future<void> setFavoritesEnabled(bool value) async {
    await _prefs.setBool(_favoritesKey, value);
  }

  Future<void> setCartEnabled(bool value) async {
    await _prefs.setBool(_cartKey, value);
  }

  Future<void> setOfflineCachingEnabled(bool value) async {
    await _prefs.setBool(_offlineCachingKey, value);
  }

  Future<void> setDebugMenuEnabled(bool value) async {
    await _prefs.setBool(_debugMenuKey, value);
  }

  Map<String, bool> getAllFlags() {
    return {
      'favorites': isFavoritesEnabled,
      'cart': isCartEnabled,
      'offlineCaching': isOfflineCachingEnabled,
      'debugMenu': isDebugMenuEnabled,
    };
  }
}
