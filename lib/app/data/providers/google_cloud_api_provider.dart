import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';

import '../../utils/GoogleHttpClient.dart';
import '../models/user_model.dart';
import 'firestore_provider.dart';

class GoogleCloudProvider {
  static final _firebaseAuthInstance = FirebaseAuth.instance;
  static GoogleSignInAccount? _currentGoogleUser;

  // Scopes for calendar access
  static const List<String> scopes = <String>[
    CalendarApi.calendarScope,
  ];

  static getInstance() async {
    HomeController homeController = Get.find<HomeController>();
    Get.put(SettingsController());
    SettingsController settingsController = Get.find<SettingsController>();

    // NOTE: Replace <YOUR_WEB_CLIENT_ID> and <YOUR_SERVER_CLIENT_ID>
    // Initialize GoogleSignIn
    await GoogleSignIn.instance.initialize(
      clientId: '<YOUR_WEB_CLIENT_ID>',
      serverClientId: '<YOUR_SERVER_CLIENT_ID>',
    );

    if (_firebaseAuthInstance.currentUser == null) {
      // Authenticate the user
      try {
        GoogleSignInAccount? googleSignInAccount;

        // Use authenticate() for v7
        if (GoogleSignIn.instance.supportsAuthenticate()) {
          googleSignInAccount = await GoogleSignIn.instance.authenticate();
        }

        if (googleSignInAccount != null) {
          _currentGoogleUser = googleSignInAccount;

          // Get the authentication object which contains idToken
          final GoogleSignInAuthentication googleAuth =
              googleSignInAccount.authentication;

          // Create Firebase credential with idToken
          final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
          );

          await _firebaseAuthInstance.signInWithCredential(credential);

          // Request calendar scopes authorization using authorizationClient
          await googleSignInAccount.authorizationClient.authorizeScopes(scopes);

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
          } else if (parts.length > 1) {
            lastName = parts[parts.length - 1]
                .toLowerCase()
                .capitalizeFirst
                .toString();
          }
          String firstName = parts[0].toLowerCase().capitalizeFirst.toString();

          var userModel = UserModel(
            id: googleSignInAccount.id,
            fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            email: googleSignInAccount.email,
          );
          // Add user to Firestore with error handling
          try {
            await FirestoreDb.addUser(userModel);
            print('✅ User synced to Firestore successfully');
          } catch (firestoreError) {
            print('⚠️ Firestore sync failed: $firestoreError');
            // Show user-friendly message but continue with local storage
            Get.snackbar(
              'Warning',
              'Cloud sync unavailable. You can still use local alarms.',
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
          await SecureStorageProvider().storeUserModel(userModel);

          settingsController.isUserLoggedIn.value = true;
          homeController.isUserSignedIn.value = true;
          homeController.userModel.value = userModel;
          settingsController.userModel.value = userModel;

          return googleSignInAccount;
        } else {
          return null;
        }
      } catch (e) {
        print('Error signing in: $e');
        return null;
      }
    } else {
      print(_firebaseAuthInstance.currentUser!.email);
    }
  }

  static bool isUserLoggedin() {
    return _firebaseAuthInstance.currentUser != null;
  }

  static Future<List<CalendarListEntry>?> getCalenders() async {
    if (_currentGoogleUser == null) {
      await _firebaseAuthInstance.signOut();
      await getInstance();
    }

    if (_currentGoogleUser == null) {
      return null;
    }

    // Get authorization headers with calendar scopes
    final authHeaders = await _currentGoogleUser!.authorizationClient
        .authorizationHeaders(scopes);

    if (authHeaders == null) {
      return null;
    }

    final httpClient = GoogleHttpClient(authHeaders);
    var dataList = await CalendarApi(httpClient).calendarList.list();

    if (dataList.items != null) {
      return dataList.items;
    } else {
      return null;
    }
  }

  static Future<List<Event>?> getEvents(String calenderId) async {
    if (_currentGoogleUser == null) {
      await getInstance();
    }

    if (_currentGoogleUser == null) {
      return null;
    }

    // Get authorization headers with calendar scopes
    final authHeaders = await _currentGoogleUser!.authorizationClient
        .authorizationHeaders(scopes);

    if (authHeaders == null) {
      return null;
    }

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

    await GoogleSignIn.instance.disconnect();
    _firebaseAuthInstance.signOut();
    await SecureStorageProvider().deleteUserModel();
    settingsController.isUserLoggedIn.value = false;
    homeController.isUserSignedIn.value = false;
    homeController.userModel.value = null;
    homeController.Calendars.value = [];
    homeController.calendarFetchStatus.value = "Loading";
    _currentGoogleUser = null;

    // Re-initialize for next sign-in
    await GoogleSignIn.instance.initialize(
      clientId: '<YOUR_WEB_CLIENT_ID>',
      serverClientId: '<YOUR_SERVER_CLIENT_ID>',
    );
  }
}
