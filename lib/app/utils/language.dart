import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:ultimate_alarm_clock/app/utils/languages/french_translations.dart';
import 'package:ultimate_alarm_clock/app/utils/languages/german_translations.dart';
import 'package:ultimate_alarm_clock/app/utils/languages/russian_translations.dart';
import 'package:ultimate_alarm_clock/app/utils/languages/spanish_translations.dart';

//this is the dictionary for every text shown in app in 5 languages
// english, german, russian, french, spanish

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'Alarm': 'Alarm',
          'Timer': 'Timer',
          'Enable 24 Hour Format': 'Enable 24 Hour Format',
          'Enable Haptic Feedback': 'Enable Haptic Feedback',
          'Enable Sorted Alarm List': 'Enable Sorted Alarm List',
          //google_sign_in.dart
          'Your account is now linked!': 'Your account is now linked!',
          'Are you sure?': 'Are you sure?',
          'unlinkAccount': 'Do you want to unlink your Google account?',
          'Unlink': 'Unlink',
          'Sign-In with Google': 'Sign-In with Google',
          'Unlink @usermail': 'Unlink @usermail',
          'Sign-In attempt failed! Please try again.': 'Sign-In attempt failed! Please try again.',
          'Sign-In failed: @error': 'Sign-In failed: @error',
          'Error': 'Error',
          'Why do I have to sign in with Google?':
              'Why do I have to sign in with Google?',
          'Sign-inDescription':
              'Signing in is optional. It is only required for the functionalities that use cloud services to work such as:',
          'CollabDescription':
              'Collaborate with friends, family members, or colleagues to ensure that they wake up on time using shared alarms.',
          'Syncing Across Devices': 'Syncing Across Devices',
          'AccessMultiple':
              'Access your alarms across multiple devices where the alarms are updated in real-time.',
          'Your privacy': 'Your privacy',
          'NoAccessInfo':
              'We do not access,  use or sell any information, which you can verify by inspecting the source code.',
          'LimitedAccess':
              'All access is limited exclusively to provide the functionalities described above.',
          'Enable Light Mode': 'Enable Light Mode',

          //home_view.dart texts
          'No upcoming alarms!': 'No upcoming alarms!',
          'Rings in @timeToAlarm': 'Rings in @timeToAlarm',
          'Show Motivational Quote': 'Show Motivational Quote',
          'Location Based': 'Location Based',
          'Next alarm': 'Next alarm',
          'About': 'About',
          'Settings': 'Settings',
          'v0.2.0': 'v0.2.0',
          'Ultimate Alarm Clock': 'Ultimate Alarm Clock',
          'Create alarm': 'Create alarm',
          'Join alarm': 'Join alarm',
          'Okay': 'Okay',
          'Yes': 'Yes',
          'No': 'No',
          'Confirmation': 'Confirmation',
          'want to delete?': 'Are you sure you want to delete this alarm?',
          'delete' : 'Delete',

          'You cannot join your own alarm!': 'You cannot join your own alarm!',
          'An alarm with this ID doesn\'t exist!':
              'An alarm with this ID doesn\'t exist!',
          'Error!': 'Error!',
          'Join': 'Join',
          'Enter Alarm ID': 'Enter Alarm ID',
          'Join an alarm': 'Join an alarm',
          'Select alarms to delete': 'Select alarms to delete',
          'No alarm selected': 'No alarm selected',
          '@noofAlarm alarms selected': '@noofAlarm alarms selected',
          'Add an alarm to get started!': 'Add an alarm to get started!',
          'Never': 'Never',
          'One Time': 'One Time',
          'Preview Alarm': 'Preview Alarm',
          'Delete Alarm': 'Delete Alarm',
          //about_view.dart texts
          'This project was originally developed as part of Google Summer of code under the CCExtractor organization. It\'s free, the source code is available, and we encourage programmers to contribute':
              'This project was originally developed as part of Google Summer of code under the CCExtractor organization. It\'s free, the source code is available, and we encourage programmers to contribute',
          'Could not launch': 'Could not launch',
          //add_or_update_alarm_view.dart
          'Discard Changes?': 'Discard Changes?',
          'unsavedChanges':
              'You have unsaved changes. Are you sure you want to leave this '
                  'page?',
          'Cancel': 'Cancel',
          'Leave': 'Leave',
          'Save': 'Save',
          'Update': 'Update',
          'Rings in @timeToAlarm': 'Rings in @timeToAlarm',
          'Uh-oh!': 'Uh-oh!',
          'alarmEditing': 'This alarm is currently being edited!',
          'Go back': 'Go back',
          'Automatic Cancellation': 'Automatic Cancellation',
          'Challenges': 'Challenges',
          'Shared Alarm': 'Shared Alarm',
          //alarm_id_tile.dart
          'Success!': 'Success!',
          'Alarm ID has been copied!': 'Alarm ID has been copied!',
          'Alarm ID': 'Alarm ID',
          'Disabled!': 'Disabled!',
          'toCopyAlarm': 'To copy Alarm ID you have enable shared alarm!',
          'Choose duration': 'Choose duration',
          'minutes': 'minutes',
          'minute': 'minute',
          'Before': 'Before',
          'After': 'After',
          'Ring before / after ': 'Ring before / after ',
          'Enabled': 'Enabled',
          'Off': 'Off',
          //choose_ringtone_tile.dart
          'Choose Ringtone': 'Choose Ringtone',
          'Default': 'Default',
          'Upload Ringtone': 'Upload Ringtone',
          'Done': 'Done',
          'Duplicate Ringtone': 'Duplicate Ringtone',
          'Choosen ringtone is already present':
              'Choosen ringtone is already present',
          //label_tile.dart
          'Label': 'Label',
          'Add a label': 'Add a label',
          'Note': 'Note',
          'noWhitespace': 'Please don\'t enter whitespace as first character!',
          //maths_challenge_tile.dart
          'Maths': 'Maths',
          'Math problems': 'Math problems',
          'mathDescription':
              'You will have to solve simple math problems of the chosen difficulty level to dismiss the alarm.',
          'Solve Maths questions': 'Solve Maths questions',
          'questions': 'questions',
          'question': 'question',
          //pedometer_challenge_tile.dart
          'Pedometer': 'Pedometer',
          'pedometerDescription': 'You will have to walk a set number of steps to dismiss the alarm.',
          //note.dart
          'Add a note': 'Add a note',
          // qr_bar_code_tile.dart
          'QR/Bar Code': 'QR/Bar Code',
          'qrDescription':
              'Scan the QR/Bar code on any object, like a book, and relocate it to a different room. To deactivate the alarm, simply rescan the same QR/Bar code.',
          //repeat_once_tile.dart
          'Repeat only once': 'Repeat only once',
          //repeat_tile.dart
          'Repeat': 'Repeat',
          'Days of the week': 'Days of the week',
          'Monday': 'Monday', 'Tuesday': 'Tuesday', 'Wednesday': 'Wednesday',
          'Thursday': 'Thursday', 'Friday': 'Friday', 'Saturday': 'Saturday',
          'Sunday': 'Sunday',
          //screen_activity_tile.dart
          'Timeout Duration': 'Timeout Duration',
          'Screen Activity': 'Screen Activity',
          'Screen activity based cancellation':
              'Screen activity based cancellation',
          'screenDescription':
              'This feature will automatically cancel the alarm if you\'ve been using your device for a set number of minutes.',
          //shake_to_dismiss_tile.dart
          'Shake to dismiss': 'Shake to dismiss',
          'shakeDescription':
              'You will have to shake your phone a set number of times to dismiss the alarm - no more lazy snoozing :)',
          'Number of shakes': 'Number of shakes',
          'times': 'times',
          'time': 'time',
          //'shared_alarm_tile.dart
          'Shared Alarm': 'Shared Alarm',
          'Shared alarms': 'Shared alarms',
          'sharedDescription':
              'Share alarms with others using the Alarm ID. Each shared user can choose to have their alarm ring before or after the set time.',
          'Understood': 'Understood',
          'To use this feature, you have to link your Google account!':
              'To use this feature, you have to link your Google account!',
          'Go to settings': 'Go to settings',
          'Enable Shared Alarm': 'Enable Shared Alarm',
          //shared_users_tile.dart
          'Alarm Owner': 'Alarm Owner',
          'Shared Users': 'Shared Users',
          'No shared users!': 'No shared users!',
          'Remove': 'Remove',
          'Select duration': 'Select duration',
          //snooze_duration_tile.dart
          'Snooze Duration': 'Snooze Duration',
          //weather_tile.dart
          'Select weather types': 'Select weather types',
          'Sunny': 'Sunny',
          'Cloudy': 'Cloudy',
          'Rainy': 'Rainy',
          'Windy': 'Windy',
          'Stormy': 'Stormy',
          'Weather Condition': 'Weather Condition',
          'Weather based cancellation': 'Weather based cancellation',
          'weatherDescription':
              'This feature will automatically cancel the alarm if the current weather matches your chosen weather conditions, allowing you to sleep better!',
          'To use this feature, you have to add an OpenWeatherMap API key!':
              'To use this feature, you have to add an OpenWeatherMap API key!',
          //alarm_challenge_view.dart
          'Shake Challenge': 'Shake Challenge',
          'Maths Challenge': 'Maths Challenge',
          'QR/Bar Code Challenge': 'QR/Bar Code Challenge',
          //maths_challenge_view.dart
          'Question @noMathQ': 'Question @noMathQ',
          //qr_challenge_view.dart
          'Scan your QR/Bar Code!': 'Scan your QR/Bar Code!',
          'Wrong Code Scanned!': 'Wrong Code Scanned!',
          'Retake': 'Retake',
          //shake_challenge_view.dart
          'Shake your phone!': 'Shake your phone!',
          //alarm_ring_view.dart
          "You can't go back while the alarm is ringing":
              "You can't go back while the alarm is ringing",
          'Start Challenge': 'Start Challenge',
          'Dismiss': 'Dismiss',
          'Exit Preview': 'Exit Preview',
          'Snooze': 'Snooze',
          //util.dart
          'Everyday': 'Everyday',
          'Weekdays': 'Weekdays',
          'Weekends': 'Weekends',
          'Mon': 'Mon', 'Tue': 'Tue', 'Wed': 'Wed', 'Thur': 'Thur',
          'Fri': 'Fri', 'Sat': 'Sat', 'Sun': 'Sun',
          //OpenWeatherMap
          'onenweathermap_title1.1': 'Steps to get ',
          'onenweathermap_title1.2': 'OpenWeatherMap API',
          'step1.1': 'Go to ',
          'step1.2': 'openweathermap.org',
          'step1.3': ', click on the ',
          'step1.4': 'SignIn',
          'step1.5':
              ' button(top right corner) then it ask for login credentials.',
          'step2.1':
              'If you already have an account then enter your credentials. Otherwise, click on ',
          'step2.2': 'Create an Account',
          'step2.3':
              ' option. It asks you to Enter your username, email, and password. Make sure entered details are correct.',
          'step3':
              'Once your account is created, you are automatically directed to the OpenWeather page. It asks you about your company and the purpose of using the platform, fill this details accordingly.',
          'step4.1': 'Click on your ',
          'step4.2': 'Username',
          'step4.3': '(top right corner). A dropdown menu appears. Click on ',
          'step4.4': 'My API',
          'step4.5': ' option.',
          'step5': 'Now you have the API key. Select the key and copy it.',
          //ascending_volume.dart
          'Volume will reach maximum in': 'Volume will reach maximum in',
          'seconds': 'seconds',
          'Adjust the volume range:': 'Adjust the volume range:',
          'Apply Gradient': 'Apply Gradient',
          'Ascending Volume': 'Ascending Volume',
        },
        'de_DE': GermanTranslations().keys['de_DE']!,
        'ru_RU': RussianTranslations().keys['ru_RU']!,
        'fr_FR': FrenchTranslations().keys['fr_FR']!,
        'es_ES': SpanishTranslations().keys['es_ES']!,
      };
}
