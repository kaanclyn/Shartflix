import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppLocale { en, tr }

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._();
  static final AppLocaleController instance = AppLocaleController._();

  static const String _key = 'app_locale';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AppLocale _locale = AppLocale.en;
  AppLocale get locale => _locale;

  Future<void> load() async {
    final String? saved = await _storage.read(key: _key);
    if (saved == 'tr') {
      _locale = AppLocale.tr;
    } else {
      _locale = AppLocale.en;
    }
    notifyListeners();
  }

  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
    await _storage.write(key: _key, value: locale == AppLocale.tr ? 'tr' : 'en');
    notifyListeners();
  }
}


