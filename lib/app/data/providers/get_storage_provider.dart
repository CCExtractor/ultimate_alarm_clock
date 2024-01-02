import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageProvider {
  late final GetStorage _getStorage;

  Future<GetStorageProvider> init() async {
    await GetStorage.init();
    _getStorage =  GetStorage();
    return this;
  }

  Future<Locale> readLocale() async {
    final languageCode = _getStorage.read('languageCode');

    return languageCode != null
        ? Locale(
      languageCode,
      _getStorage.read('countryCode') ?? '',
    ) : const Locale('en', 'EN');
  }

  Future<void> writeLocale(String lanCode, String countryCode) async {
    await _getStorage.write('languageCode', lanCode);
    await _getStorage.write('countryCode', countryCode);
  }

}


