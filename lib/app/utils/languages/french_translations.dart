// ignore_for_file: lines_longer_than_80_chars

import 'package:get/get.dart';

class FrenchTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'fr_FR': {
          'Alarm': 'Réveil',
          'Timer': 'Minuteur',
          'StopWatch': 'Chronomètre',
          'Enable 24 Hour Format': 'Activer le format 24 heures',
          'Enable Haptic Feedback': 'Activer les commentaires haptiques',
          'Enable Sorted Alarm List': 'Activer la liste de réveils triée',
          // google_sign_in.dart
          'Your account is now linked!': 'Votre compte est maintenant lié !',
          'Are you sure?': 'Êtes-vous sûr ?',
          'unlinkAccount': 'Voulez-vous vraiment délier votre compte Google ?',
          'Unlink': 'Délier',
          'Sign-In with Google': 'Connexion avec Google',
          'Unlink @usermail': 'Délier @usermail',
          'Why do I have to sign in with Google?':
              'Pourquoi dois-je me connecter avec Google ?',
          'Sign-inDescription':
              'La connexion est facultative. Elle est uniquement nécessaire pour les fonctionnalités qui utilisent des services cloud, tels que :',
          'CollabDescription':
              'Collaborez avec des amis, des membres de la famille ou des collègues pour vous assurer qu\'ils se réveillent à temps à l\'aide d\'alarmes partagées.',
          'Syncing Across Devices': 'Synchronisation entre les appareils',
          'AccessMultiple':
              'Accédez à vos alarmes sur plusieurs appareils où les alarmes sont mises à jour en temps réel.',
          'Your privacy': 'Votre vie privée',
          'NoAccessInfo':
              'Nous n\'accédons pas, n\'utilisons pas et ne vendons aucune information, ce que vous pouvez vérifier en inspectant le code source.',
          'LimitedAccess':
              'Tout accès est limité exclusivement à la fourniture des fonctionnalités décrites ci-dessus.',
          'Enable Light Mode': 'Activer le mode clair',
          'Change Language': 'Changer de langue',
          'English': 'Anglais',
          'Spanish': 'Espagnol',
          'German': 'Allemand',
          'French': 'Français',
          'Russian': 'Russe',

          'No upcoming alarms!': 'Pas d\'alarmes à venir !',
          'Next alarm': 'Prochain réveil',
          'Show Motivational Quote': 'Afficher une citation motivante',
          //home_view.dart
          'About': 'À propos',
          'Settings': 'Paramètres',
          'v0.5.0': 'v0.5.0',
          'Ultimate Alarm Clock': 'Réveil Ultime',
          'Create alarm': 'Créer un réveil',
          'Join alarm': 'Rejoindre un réveil',
          'Okay': 'D\'accord',
          'Yes': 'Oui',
          'No': 'Non',
          'Confirmation': 'Confirmation',
          'want to delete?':
              'Êtes-vous sûr de vouloir supprimer cette alarme ?',
          'You cannot join your own alarm!':
              'Vous ne pouvez pas rejoindre votre propre réveil !',
          'An alarm with this ID doesn\'t exist!':
              'Un réveil avec cet identifiant n\'existe pas !',
          'Error!': 'Erreur !',
          'Join': 'Rejoindre',
          'Enter Alarm ID': 'Entrer l\'identifiant du réveil',
          'Join an alarm': 'Rejoindre un réveil',
          'Select alarms to delete': 'Sélectionnez les réveils à supprimer',
          'No alarm selected': 'Aucun réveil sélectionné',
          '1 alarm selected': '1 réveil sélectionné',
          ' alarms selected': ' réveils sélectionnés',
          'Add an alarm to get started!': 'Ajoutez un réveil pour commencer !',
          'Never': 'Jamais',
          'One Time': 'Une fois',
          'Preview Alarm': 'Aperçu du réveil',
          'Delete Alarm': 'Supprimer le réveil',
          'Are you sure you want to delete these alarms?':
              'Êtes-vous sûr(e) de vouloir supprimer ces alarmes ?',
          'This action will permanently delete these alarms from your device.':
              'Cette action supprimera définitivement ces alarmes de votre appareil.',

          //about_view.dart texts
          'This project was originally developed as part of Google Summer of code under the CCExtractor organization. It\'s free, the source code is available, and we encourage programmers to contribute':
              'Ce projet a été initialement développé dans le cadre du Google Summer of Code sous l\'organisation CCExtractor. Il est gratuit, le code source est disponible et nous encourageons les programmeurs à contribuer.',
          'Could not launch': 'Impossible de lancer',
//add_or_update_alarm_view.dart
          'Discard Changes?': 'Ignorer les modifications ?',
          'unsavedChanges':
              'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter cette page ?',
          'Cancel': 'Annuler',
          'Leave': 'Quitter',
          'Save': 'Enregistrer',
          'Update': 'Mettre à jour',
          'Rings in @timeToAlarm': 'Sonner dans @timeToAlarm',
          'Uh-oh!': 'Oups !',
          'alarmEditing': "Cet alarme est actuellement en cours d'édition !",
          'Go back': 'Retour',
          'Automatic Cancellation': 'Annulation automatique',
          'Challenges': 'Défis',
          'Shared Alarm': 'Alarme partagée',
          'Camera Permission': 'Autorisation de la caméra',
          'Please allow camera access to scan QR codes.':
              'Veuillez autoriser l\'accès à la caméra pour scanner les codes QR.',
          'OK': "D'accord",
//alarm_id_tile.dart
          'Success!': 'Succès !',
          'Alarm ID has been copied!': "L'ID de l'alarme a été copié !",
          'Alarm ID': "ID de l'alarme",
          'Disabled!': 'Désactivé !',
          'toCopyAlarm':
              "Pour copier l'ID de l'alarme, vous devez activer l'alarme partagée !",
          'Choose duration': 'Choisir la durée',
          'minutes': 'minutes',
          'minute': 'minute',
          'Before': 'Avant',
          'After': 'Après',
          'Ring before / after ': 'Sonner avant / après ',
          'Enabled': 'Activé',
          'Off': 'Désactivé',
//choose_ringtone_tile.dart
          'Choose Ringtone': 'Choisir une sonnerie',
          'Default': 'Par défaut',
          'Upload Ringtone': 'Télécharger une sonnerie',
          'Done': 'Terminé',
          'Duplicate Ringtone': 'Sonnerie en double',
          'Choosen ringtone is already present':
              'La sonnerie choisie est déjà présente',
//delete_tile.dart
          'Delete After Goes Off': 'Supprimer après la fin',

//label_tile.dart
          'Label': 'Étiquette',
          'Enter a name': 'Entrez un nom',
          'Add a label': 'Ajouter une étiquette',
          'Note': 'Note',
          'noWhitespace':
              'Veuillez ne pas entrer d\'espace en tant que premier caractère !',
//maths_challenge_tile.dart
          'Maths': 'Mathématiques',
          'Math problems': 'Problèmes mathématiques',

          'Easy': 'Facile',
          'Medium': 'Moyen',
          'Hard': 'Difficile',

          'mathDescription':
              'Vous devrez résoudre des problèmes mathématiques simples du niveau de difficulté choisi pour désactiver l\'alarme.',
          'Solve Maths questions': 'Résoudre des questions de mathématiques',
          'questions': 'questions',
          'question': 'question',

          'Pedometer': 'Podomètre',
          'Number of steps': 'Nombre de pas',
          'step': 'étape',
          'steps': 'pas',
          'pedometerDescription':
              'Avancez pour rejeter! Fixez un objectif en nombre de pas pour éteindre votre alarme, favorisant un début de journée actif et plein d\'énergie.',

//note.dart
          'Add a note': 'Ajouter une note',
// qr_bar_code_tile.dart
          'QR/Bar Code': 'QR/Code-barres',
          'qrDescription':
              'Scannez le QR/Code-barres sur n\'importe quel objet, comme un livre, et déplacez-le dans une pièce différente. Pour désactiver l\'alarme, scannez à nouveau le même QR/Code-barres.',

//photo_challenge_tile.dart
          'Take': 'Prendre',
          'Retake': 'Reprendre',
          'Disable': 'Désactiver',
          'Photo': 'Photo',
          'photoDescription':
              "L'application ultime de défi photo qui transforme la capture de moments en un jeu palpitant ! Prenez une photo pour lancer le défi, puis défiez le temps pour la recréer et arrêter l'alarme. Êtes-vous prêt pour le défi ?",
          'Take Photo': 'Prendre une photo',
          'Capture a Photo': 'Capturer une photo',
//repeat_once_tile.dart
          'Repeat only once': 'Répéter une seule fois',
//repeat_tile.dart
          'Repeat': 'Répéter',
          'Days of the week': 'Jours de la semaine',
          'Monday': 'Lundi', 'Tuesday': 'Mardi', 'Wednesday': 'Mercredi',
          'Thursday': 'Jeudi', 'Friday': 'Vendredi', 'Saturday': 'Samedi',
          'Sunday': 'Dimanche',
//screen_activity_tile.dart
          'Timeout Duration': 'Durée d\'expiration',
          'Screen Activity': 'Activité de l\'écran',
          'Screen activity based cancellation':
              'Annulation basée sur l\'activité de l\'écran',
          'screenDescription':
              "Cette fonction annulera automatiquement l'alarme si vous utilisez votre appareil pendant un certain nombre de minutes.",
//shake_to_dismiss_tile.dart
          'Shake to dismiss': 'Secouez pour rejeter',
          'shakeDescription':
              'Vous devrez secouer votre téléphone un certain nombre de fois pour rejeter l\'alarme - fini la procrastination :)',
          'Number of shakes': 'Nombre de secousses',
          'times': 'fois',
          'time': 'fois',
//'shared_alarm_tile.dart
          'Shared Alarm': 'Alarme partagée',
          'Shared alarms': 'Alarmes partagées',
          'sharedDescription':
              'Partagez des alarmes avec d\'autres en utilisant l\'ID de l\'alarme. Chaque utilisateur partagé peut choisir de faire sonner son alarme avant ou après l\'heure définie.',
          'Understood': 'Compris',
          'To use this feature, you have to link your Google account!':
              'Pour utiliser cette fonctionnalité, vous devez lier votre compte Google !',
          'Go to settings': 'Aller aux paramètres',
          'Enable Shared Alarm': 'Activer l\'alarme partagée',
//shared_users_tile.dart
          'Alarm Owner': 'Propriétaire de l\'alarme',
          'Shared Users': 'Utilisateurs partagés',
          'No shared users!': 'Aucun utilisateur partagé !',
          'Remove': 'Supprimer',
          'Select duration': 'Sélectionner la durée',
//snooze_duration_tile.dart
          'Snooze Duration': 'Durée de l\'hibernation',
//weather_tile.dart
          'Select weather types': 'Sélectionner les types de temps',
          'Sunny': 'Ensoleillé',
          'Cloudy': 'Nuageux',
          'Rainy': 'Pluvieux',
          'Windy': 'Venteux',
          'Stormy': 'Orageux',
          'Weather Condition': 'Conditions météorologiques',
          'Weather based cancellation': 'Annulation basée sur la météo',
          'weatherDescription':
              'Cette fonction annulera automatiquement l\'alarme si la météo actuelle correspond à vos conditions météorologiques choisies, vous permettant de mieux dormir !',
          'To use this feature, you have to add an OpenWeatherMap API key!':
              'Pour utiliser cette fonction, vous devez ajouter une clé API OpenWeatherMap !',
//alarm_challenge_view.dart
          'Shake Challenge': 'Défi de secousses',
          'Maths Challenge': 'Défi mathématique',
          'QR/Bar Code Challenge': 'Défi QR/Code-barres',
//maths_challenge_view.dart
          'Question @noMathQ': 'Question @noMathQ',
//qr_challenge_view.dart
          'Scan your QR/Bar Code!': 'Scannez votre QR/Code-barres !',
          'Wrong Code Scanned!': 'Code incorrect scanné !',
          'Retake': 'Recommencer',
//shake_challenge_view.dart
          'Shake your phone!': 'Secouez votre téléphone !',
//alarm_ring_view.dart
          "You can't go back while the alarm is ringing":
              "Vous ne pouvez pas revenir tant que l'alarme sonne",
          'Start Challenge': 'Commencer le défi',
          'Dismiss': 'Rejeter',
          'Exit Preview': 'Quitter l\'aperçu',
          'Snooze': 'Hibernation',
          //utils.dart
          'Location Based': 'Basé sur la localisation',
          'Everyday': 'Tous les jours',
          'Weekdays': 'Jours de la semaine',
          'Weekends': 'Week-ends',
          'Mon': 'Lun', 'Tue': 'Mar', 'Wed': 'Mer', 'Thur': 'Jeu',
          'Fri': 'Ven', 'Sat': 'Sam', 'Sun': 'Dim',
          //OpenWeatherMap
          'onenweathermap_title1.1': 'Étapes pour obtenir ',
          'onenweathermap_title1.2': 'OpenWeatherMap API',
          'step1.1': 'Aller à ',
          'step1.2': 'openweathermap.org',
          'step1.3': ', cliquez sur le bouton ',
          'step1.4': 'SignIn',
          'step1.5':
              ' (le coin supérieur droit) puis il demande les informations de connexion.',
          'step2.1':
              "Si vous avez déjà un compte, entrez vos identifiants. Sinon, cliquez sur l'option ",
          'step2.2': 'Create an Account',
          'step2.3':
              ". Il vous demande de saisir votre nom d'utilisateur, votre e-mail et votre mot de passe. Assurez-vous que les détails sont corrects.",
          'step3':
              "Une fois votre compte prêt, vous êtes automatiquement dirigé vers la page OpenWeather. Il vous pose des questions sur votre entreprise et le but de l'utilisation de la plateforme, remplissez ces informations en conséquence.",
          'step4.1': 'Cliquez sur votre ',
          'step4.2': 'Username',
          'step4.3':
              "(le coin supérieur droit). Un menu déroulant apparaît. cliquez sur l'option ",
          'step4.4': 'My API',
          'step4.5': '.',
          'step5':
              'Vous disposez désormais de la clé API Météo. Sélectionnez la clé et copiez-la.',

          //ascending_volume.dart
          'Volume will reach maximum in':
              'Le volume atteindra son maximum dans',
          'seconds': 'secondes',
          'Adjust the volume range:': 'Ajustez la plage de volume:',
          'Apply Gradient': 'Appliquer un dégradé',
          'Ascending Volume': 'Volume croissant',
          'Alarm deleted': 'Alarme supprimée',
          'The alarm has been deleted': "L'alarme a été supprimée",
          'Undo': 'annuler',
        },
      };
}
