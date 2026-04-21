import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimate_alarm_clock/app/data/models/world_clock_model.dart';

class GetStorageProvider {
  late final GetStorage _getStorage;

  Future<GetStorageProvider> init() async {
    await GetStorage.init();
    _getStorage = GetStorage();
    return this;
  }

  Future<String> readCurrentLanguage() async {
    print(_getStorage.read('currentLanguageKey'));
    String? language = await _getStorage.read(('currentLanguageKey'));
    if (language == null) {
      language = Get.locale.toString();
      writeCurrentLanguage(language);
    }
    return language;
  }

  Future<void> writeCurrentLanguage(String value) async {
    await _getStorage.write('currentLanguageKey', value);
  }

  Future<Locale> readLocale() async {
    final languageCode = _getStorage.read('languageCode');

    return languageCode != null
        ? Locale(
            languageCode,
            _getStorage.read('countryCode') ?? '',
          )
        : const Locale('en', 'EN');
  }

  Future<void> writeLocale(String lanCode, String countryCode) async {
    await _getStorage.write('languageCode', lanCode);
    await _getStorage.write('countryCode', countryCode);
  }

  Future<void> writeProfile(String profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _getStorage.write('profile', profile);
    await prefs.setString('profile', profile);
  }

  Future<String> readProfile() async {
    String profile = await _getStorage.read('profile') ?? 'Default';
    return profile;
  }

  List<WorldClockModel> readWorldClocks() {
    final List<dynamic>? raw = _getStorage.read<List>('worldClocks');
    if (raw == null) return [];
    return raw
        .map((e) => WorldClockModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void writeWorldClocks(List<WorldClockModel> clocks) {
    _getStorage.write('worldClocks', clocks.map((e) => e.toJson()).toList());
  }

  Future<void> writePomodoroState(Map<String, dynamic> state) async {
    await _getStorage.write('pomodoroState', state);
  }

  Map<String, dynamic>? readPomodoroState() {
    final dynamic raw = _getStorage.read('pomodoroState');
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  Future<void> clearPomodoroState() async {
    await _getStorage.remove('pomodoroState');
  }
}
