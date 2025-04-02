import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';

import '../../utils/GoogleHttpClient.dart';
import '../models/user_model.dart';
import 'firestore_provider.dart';

class GoogleCloudProvider {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      CalendarApi.calendarScope,
    ],
  );
  static final _firebaseAuthInstance = FirebaseAuth.instance;

  static getInstance() async {
    HomeController homeController = Get.find<HomeController>();
    Get.put(SettingsController());
    SettingsController settingsController = Get.find<SettingsController>();

    if (await _firebaseAuthInstance.currentUser == null) {
      var googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;
      if (googleAuth != null)
      {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await _firebaseAuthInstance.signInWithCredential(credential);
      }


      if (googleSignInAccount != null) {
        // Process successful sign-in
        String fullName = googleSignInAccount.displayName.toString();
        List<String> parts = fullName.split(' ');
        String lastName = ' ';
        if (parts.length == 3) {
          if (parts[parts.length - 1].length == 1) {
            lastName = parts[1].toLowerCase().capitalizeFirst.toString();
          } else {
            lastName = parts[parts.length - 1]
                .toLowerCase()
                .capitalizeFirst
                .toString();
          }
        } else {
          lastName =
              parts[parts.length - 1].toLowerCase().capitalizeFirst.toString();
        }
        String firstName = parts[0].toLowerCase().capitalizeFirst.toString();

        var userModel = UserModel(
          id: googleSignInAccount.id,
          fullName: fullName,
          firstName: firstName,
          lastName: lastName,
          email: googleSignInAccount.email,
        );
        await FirestoreDb.addUser(userModel);
        await SecureStorageProvider().storeUserModel(userModel);

        settingsController.isUserLoggedIn.value = true;
        homeController.isUserSignedIn.value = true;
        homeController.userModel.value = userModel;
        settingsController.userModel.value = userModel;
        return googleSignInAccount;
      } else {
        return null;
      }
    } else {
      print(_firebaseAuthInstance.currentUser!.email);
    }
  }

  static isUserLoggedin()  {
    return  _firebaseAuthInstance.currentUser != null;
  }

  static Future<List<CalendarListEntry>?> getCalenders() async {
    if (_googleSignIn.currentUser == null) {
      await _firebaseAuthInstance.signOut();
      await getInstance();
    }
    final authHeaders = await _googleSignIn.currentUser!.authHeaders;
    final httpClient = GoogleHttpClient(authHeaders);
    var dataList = await CalendarApi(httpClient).calendarList.list();

    if (dataList.items != null) {
      return dataList.items;
    } else {
      return null;
    }
  }

  static Future<List<Event>?> getEvents(String calenderId) async {
    await getInstance();
    final authHeaders = await _googleSignIn.currentUser!.authHeaders;
    final httpClient = GoogleHttpClient(authHeaders);
    var dataList = await CalendarApi(httpClient).events.list(calenderId);
    if (dataList.items != null) {
      return dataList.items;
    } else {
      return null;
    }
  }

  static Future<void> logoutGoogle() async {
    HomeController homeController = Get.find<HomeController>();
    Get.put(SettingsController());
    SettingsController settingsController = Get.find<SettingsController>();

    await _googleSignIn.signOut();
    _firebaseAuthInstance.signOut();
    await SecureStorageProvider().deleteUserModel();
    settingsController.isUserLoggedIn.value = false;
    homeController.isUserSignedIn.value = false;
    homeController.userModel.value = null;
    homeController.Calendars.value = [];
    homeController.calendarFetchStatus.value = "Loading";
  }
}
