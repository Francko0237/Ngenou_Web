import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  fr('fr', 'Français', 'FR'),
  en('en', 'English', 'EN');

  final String code;
  final String label;
  final String shortLabel;

  const AppLanguage(this.code, this.label, this.shortLabel);

  static AppLanguage fromCode(String? code) {
    if (code?.toLowerCase().startsWith('en') == true) {
      return AppLanguage.en;
    }
    return AppLanguage.fr;
  }
}

class AppLanguageNotifier extends StateNotifier<AppLanguage> {
  static const String _prefKey = 'ngenou_web_language_pref';

  AppLanguageNotifier() : super(AppLanguage.fr) {
    _initLocale();
  }

  Future<void> _initLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null) {
        state = AppLanguage.fromCode(savedCode);
      }
    } catch (_) {}
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (state == lang) return;
    state = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, lang.code);
    } catch (_) {}
  }

  void toggle() {
    setLanguage(state == AppLanguage.fr ? AppLanguage.en : AppLanguage.fr);
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLanguageNotifier, AppLanguage>((ref) {
  return AppLanguageNotifier();
});
