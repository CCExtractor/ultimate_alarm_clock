import 'dart:ui';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';

class LanguageController extends GetxController{
  final storage=Get.find<GetStorageProvider>();
  final RxString local = Get.locale.toString().obs;

  final Map<String, dynamic> optionslocales = {
    'en_US' : {
      'languageCode' : 'en',
      'countryCode' : 'US',
      'description' : 'English',
    },
    'de_DE' : {
      'languageCode' : 'de',
      'countryCode' : 'DE',
      'description' : 'German',
    },
    'ru_RU' : {
      'languageCode' : 'ru',
      'countryCode' : 'RU',
      'description' : 'Russian',
    },
    'fr_FR' : {
      'languageCode' : 'fr',
      'countryCode' : 'FR',
      'description' : 'French',
    },
    'es_ES' : {
      'languageCode' : 'es',
      'countryCode' : 'ES',
      'description' : 'Spanish',
    },
};

  void updateLocale(String key){
    final String languageCode = optionslocales[key]['languageCode'];
    final String countryCode = optionslocales[key]['countryCode'];
    Get.updateLocale(Locale(languageCode, countryCode));
    local.value=Get.locale.toString();
    storage.writeLocale(languageCode, countryCode);
  }
}