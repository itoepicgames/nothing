import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }
enum AppLanguage { english, arabic }

class SettingsService {
  static const _themeKey = 'theme_mode';
  static const _languageKey = 'language';
  static const _hapticsKey = 'haptics';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<AppThemeMode> loadTheme() async {
    final value = await _prefs.getString(_themeKey);
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<AppLanguage> loadLanguage() async {
    final value = await _prefs.getString(_languageKey);
    return AppLanguage.values.firstWhere(
      (language) => language.name == value,
      orElse: () => AppLanguage.english,
    );
  }

  Future<bool> loadHaptics() async => await _prefs.getBool(_hapticsKey) ?? true;

  Future<void> saveTheme(AppThemeMode mode) => _prefs.setString(_themeKey, mode.name);
  Future<void> saveLanguage(AppLanguage language) => _prefs.setString(_languageKey, language.name);
  Future<void> saveHaptics(bool enabled) => _prefs.setBool(_hapticsKey, enabled);
}
