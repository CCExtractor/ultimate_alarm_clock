import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/about/views/about_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutController extends GetxController {
  final RxBool isAboutExpanded = true.obs;

  static const String ccExtractorUrl = 'https://ccextractor.org/';
  static const String githubUrl =
      'https://github.com/CCExtractor/ultimate_alarm_clock';

  Future<bool> launchUrl(Uri uri) async {
    if (await canLaunchUrlString(uri.toString())) {
      return await launchUrlString(uri.toString());
    } else {
      return false;
    }
  }

  void toggleAboutExpansion() {
    isAboutExpanded.value = !isAboutExpanded.value;
  }

  void navigateToAboutView() {
    Get.to(() => AboutView());
  }
}
