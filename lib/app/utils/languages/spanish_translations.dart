import 'package:get/get.dart';

class SpanishTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'es_ES': {
          'Alarm': 'Alarma',
          'Timer': 'Temporizador',
          'StopWatch': 'Cronómetro',

          'Enable 24 Hour Format': 'Habilitar formato de 24 horas',
          'Enable Haptic Feedback': 'Habilitar retroalimentación háptica',
          'Enable Sorted Alarm List': 'Habilitar lista de alarmas ordenada',
          // google_sign_in.dart
          'Your account is now linked!': '¡Su cuenta ahora está vinculada!',
          'Are you sure?': '¿Estás seguro?',
          'unlinkAccount':
              '¿Seguro que quieres desvincular tu cuenta de Google?',
          'Unlink': 'Desvincular',
          'Sign-In with Google': 'Iniciar sesión con Google',
          'Unlink @usermail': 'Desvincular @usermail',
          'Why do I have to sign in with Google?':
              '¿Por qué tengo que iniciar sesión con Google?',
          'Sign-inDescription':
              'Iniciar sesión es opcional. Solo es necesario para las funciones que utilizan servicios en la nube, como:',
          'CollabDescription':
              'Colabore con amigos, familiares o colegas para asegurarse de que se despierten a tiempo utilizando alarmas compartidas.',
          'Syncing Across Devices': 'Sincronización entre dispositivos',
          'AccessMultiple':
              'Acceda a sus alarmas desde varios dispositivos donde las alarmas se actualizan en tiempo real.',
          'Your privacy': 'Tu privacidad',
          'NoAccessInfo':
              'No accedemos, no usamos ni vendemos ninguna información, lo cual puedes verificar inspeccionando el código fuente.',
          'LimitedAccess':
              'Todo el acceso está limitado exclusivamente para proporcionar las funcionalidades descritas anteriormente.',
          'Enable Light Mode': 'Habilitar modo claro',
          'Change Language': 'Cambiar Idioma',
          'English': 'Inglés',
          'Spanish': 'Español',
          'German': 'Alemán',
          'French': 'Francés',
          'Russian': 'Ruso',

          'No upcoming alarms!': '¡No hay alarmas próximas!',
          'Next alarm': 'Próxima alarma',
          'Show Motivational Quote': 'Mostrar cita motivadora',
          //home_view.dart
          'About': 'Acerca de',
          'Settings': 'Configuración',
          'v0.5.0': 'v0.5.0',
          'Ultimate Alarm Clock': 'Reloj Despertador Definitivo',
          'Create alarm': 'Crear alarma',
          'Join alarm': 'Unirse a alarma',
          'Okay': 'Aceptar',
          'Yes': 'Sí',
          'No': 'No',
          'Confirmation': 'Confirmación',
          'want to delete?': '¿Estás seguro de que deseas eliminar esta alarma?',
          'delete':'borrar',
          'You cannot join your own alarm!':
              '¡No puedes unirte a tu propia alarma!',
          'An alarm with this ID doesn\'t exist!':
              '¡Una alarma con este ID no existe!',
          'Error!': '¡Error!',
          'Join': 'Unirse',
          'Enter Alarm ID': 'Ingresar ID de alarma',
          'Join an alarm': 'Unirse a una alarma',
          'Select alarms to delete': 'Seleccionar alarmas para eliminar',
          'No alarm selected': 'Ninguna alarma seleccionada',
          '1 alarm selected': '1 alarma seleccionada',
          ' alarms selected': ' alarmas seleccionadas',
          'Add an alarm to get started!': '¡Añade una alarma para empezar!',
          'Never': 'Nunca',
          'One Time': 'Una vez',
          'Preview Alarm': 'Vista previa de alarma',
          'Delete Alarm': 'Eliminar alarma',
          //about_view.dart texts
          'This project was originally developed as part of Google Summer of code under the CCExtractor organization. It\'s free, the source code is available, and we encourage programmers to contribute':
              'Este proyecto fue desarrollado originalmente como parte del Google Summer of Code bajo la organización CCExtractor. Es gratuito, el código fuente está disponible y animamos a los programadores a contribuir.',
          'Could not launch': 'No se pudo iniciar',
//add_or_update_alarm_view.dart
          'Discard Changes?': '¿Descartar cambios?',
          'unsavedChanges':
              'Tiene cambios no guardados. ¿Está seguro de que desea salir de esta página?',
          'Cancel': 'Cancelar',
          'Leave': 'Salir',
          'Save': 'Guardar',
          'Update': 'Actualizar',
          'Rings in @timeToAlarm': 'Suena en @timeToAlarm',
          'Uh-oh!': '¡Ay!',
          'alarmEditing': '¡Esta alarma se está editando actualmente!',
          'Go back': 'Volver',
          'Automatic Cancellation': 'Cancelación automática',
          'Challenges': 'Desafíos',
          'Shared Alarm': 'Alarma compartida',
          'Camera Permission': 'Permiso de cámara',
          'Please allow camera access to scan QR codes.':
              'Por favor, permita el acceso a la cámara para escanear códigos QR.',
          'OK': 'De \n acuerdo',

//alarm_id_tile.dart
          'Success!': '¡Éxito!',
          'Alarm ID has been copied!': '¡Se ha copiado el ID de la alarma!',
          'Alarm ID': 'ID de la alarma',
          'Disabled!': '¡Desactivado!',
          'toCopyAlarm':
              'Para copiar el ID de la alarma, debes habilitar la alarma compartida!',
          'Choose duration': 'Elegir duración',
          'minutes': 'minutos',
          'minute': 'minuto',
          'Before': 'Antes',
          'After': 'Después',
          'Ring before / after ': 'Sonar antes / después ',
          'Enabled': 'Habilitado',
          'Off': 'Apagado',
//choose_ringtone_tile.dart
          'Choose Ringtone': 'Elegir tono de llamada',
          'Default': 'Predeterminado',
          'Upload Ringtone': 'Subir tono de llamada',
          'Done': 'Hecho',
          'Duplicate Ringtone': 'Tono duplicado',
          'Choosen ringtone is already present':
              'El tono de llamada elegido ya está presente',
          //delete_tile.dart
          'Delete After Goes Off': 'Eliminar después de que expire',

//label_tile.dart
          'Label': 'Etiqueta',
          'Add a label': 'Agregar una etiqueta',
          'Note': 'Nota',
          'noWhitespace':
              'Por favor, no ingrese espacios en blanco como primer carácter!',

//maths_challenge_tile.dart
          'Maths': 'Matemáticas',
          'Math problems': 'Problemas matemáticos',
          'Easy': 'Fácil',
          'Medium': 'Medio',
          'Hard': 'Difícil',

//maths_challenge_tile.dart
          'Maths': 'Matemáticas',
          'Math problems': 'Problemas matemáticos',
          'mathDescription':
              'Deberá resolver problemas matemáticos simples del nivel de dificultad elegido para desactivar la alarma.',
          'Solve Maths questions': 'Resolver preguntas de matemáticas',
          'questions': 'preguntas',
          'question': 'pregunta',

          // pedometer_challenge_tile.dart
          'Pedometer': 'Podómetro',
          'Number of steps': 'Numero de pasos',
          'step': 'paso',
          'steps': 'pasos',
          'pedometerDescription':
              '¡Avance para despedir! Establezca una meta de pasos para apagar la alarma, promoviendo un comienzo del día activo y lleno de energía.',
//note.dart
          'Add a note': 'Agrega una nota',
// qr_bar_code_tile.dart
          'QR/Bar Code': 'Código QR/Código de barras',
          'qrDescription':
              'Escanee el código QR/código de barras en cualquier objeto, como un libro, y muévalo a una habitación diferente. Para desactivar la alarma, simplemente vuelva a escanear el mismo código QR/código de barras.',
//repeat_once_tile.dart
          'Repeat only once': 'Repetir solo una vez',
//repeat_tile.dart
          'Repeat': 'Repetir',
          'Days of the week': 'Días de la semana',
          'Monday': 'Lunes', 'Tuesday': 'Martes', 'Wednesday': 'Miércoles',
          'Thursday': 'Jueves', 'Friday': 'Viernes', 'Saturday': 'Sábado',
          'Sunday': 'Domingo',
//screen_activity_tile.dart
          'Timeout Duration': 'Duración de tiempo de espera',
          'Screen Activity': 'Actividad de la pantalla',
          'Screen activity based cancellation':
              'Cancelación basada en la actividad de la pantalla',
          'screenDescription':
              'Esta función cancelará automáticamente la alarma si ha estado utilizando su dispositivo durante un número determinado de minutos.',
//shake_to_dismiss_tile.dart
          'Shake to dismiss': 'Agitar para descartar',
          'shakeDescription':
              'Tendrá que agitar su teléfono un número determinado de veces para descartar la alarma, ¡nada de posponer perezosamente :)',
          'Number of shakes': 'Número de sacudidas',
          'times': 'veces',
          'time': 'vez',
//'shared_alarm_tile.dart
          'Shared Alarm': 'Alarma compartida',
          'Shared alarms': 'Alarmas compartidas',
          'sharedDescription':
              'Comparta alarmas con otros utilizando el ID de la alarma. Cada usuario compartido puede elegir hacer sonar su alarma antes o después del tiempo establecido.',
          'Understood': 'Entendido',
          'To use this feature, you have to link your Google account!':
              'Para usar esta función, debe vincular su cuenta de Google!',
          'Go to settings': 'Ir a configuración',
          'Enable Shared Alarm': 'Habilitar alarma compartida',
//shared_users_tile.dart
          'Alarm Owner': 'Propietario de la alarma',
          'Shared Users': 'Usuarios compartidos',
          'No shared users!': '¡No hay usuarios compartidos!',
          'Remove': 'Eliminar',
          'Select duration': 'Seleccionar duración',
//snooze_duration_tile.dart
          'Snooze Duration': 'Duración de la siesta',
//weather_tile.dart
          'Select weather types': 'Seleccionar tipos de clima',
          'Sunny': 'Soleado',
          'Cloudy': 'Nublado',
          'Rainy': 'Lluvioso',
          'Windy': 'Ventoso',
          'Stormy': 'Tormentoso',
          'Weather Condition': 'Condición meteorológica',
          'Weather based cancellation': 'Cancelación basada en el clima',
          'weatherDescription':
              'Esta función cancelará automáticamente la alarma si el clima actual coincide con las condiciones climáticas elegidas, ¡permitiéndote dormir mejor!',
          'To use this feature, you have to add an OpenWeatherMap API key!':
              'Para usar esta función, debe agregar una clave API de OpenWeatherMap!',
//alarm_challenge_view.dart
          'Shake Challenge': 'Desafío de agitación',
          'Maths Challenge': 'Desafío de matemáticas',
          'QR/Bar Code Challenge': 'Desafío de código QR/código de barras',
//maths_challenge_view.dart
          'Question @noMathQ': 'Pregunta @noMathQ',
//qr_challenge_view.dart
          'Scan your QR/Bar Code!': '¡Escanee su código QR/código de barras!',
          'Wrong Code Scanned!': '¡Código incorrecto escaneado!',
          'Retake': 'Repetir',
//shake_challenge_view.dart
          'Shake your phone!': '¡Agita tu teléfono!',
//alarm_ring_view.dart
          "You can't go back while the alarm is ringing":
              "No puedes retroceder mientras suena la alarma",
          'Start Challenge': 'Comenzar el desafío',
          'Dismiss': 'Descartar',
          'Exit Preview': 'Salir de la vista previa',
          'Snooze': 'Siesta',
          //utils.dart
          'Location Based': 'Basado en la ubicación',
          'Everyday': 'Todos los días',
          'Weekdays': 'Días laborables',
          'Weekends': 'Fines de semana',
          'Mon': 'Lun', 'Tue': 'Mar', 'Wed': 'Mié', 'Thur': 'Jue',
          'Fri': 'Vie', 'Sat': 'Sáb', 'Sun': 'Dom',
          //OpenWeatherMap
          'onenweathermap_title1.1': 'Pasos para conseguir ',
          'onenweathermap_title1.2': 'OpenWeatherMap API',
          'step1.1': 'Ir a ',
          'step1.2': 'openweathermap.org',
          'step1.3': ', haga clic en el botón ',
          'step1.4': 'SignIn',
          'step1.5':
              ' (esquina superior derecha) luego solicita las credenciales de inicio de sesión.',
          'step2.1':
              'Si ya tiene una cuenta, ingrese sus credenciales. De lo contrario, haga clic en la opción ',
          'step2.2': 'Create an Account',
          'step2.3':
              '. Le pide que ingrese su nombre de usuario, correo electrónico y contraseña. Asegúrate de que los detalles sean correctos.',
          'step3':
              'Una vez que su cuenta esté lista, se le dirigirá automáticamente a la página de OpenWeather. Te pregunta sobre tu empresa y el propósito de uso de la plataforma, complete estos detalles en consecuencia.',
          'step4.1': 'Haga clic en su ',
          'step4.2': 'Username',
          'step4.3':
              '(esquina superior derecha). Aparece un menú desplegable. Haga clic en la opción ',
          'step4.4': 'My API',
          'step4.5': '.',
          'step5': 'Ahora tienes la API. Seleccione la API y cópiela.',
          //ascending_volume.dart
          'Volume will reach maximum in': 'El volumen alcanzará el máximo en',
          'seconds': 'segundos',
          'Adjust the volume range:': 'Ajustar el rango de volumen:',
          'Apply Gradient': 'Aplicar degradado',
          'Ascending Volume': 'Volumen ascendente',
          'Alarm deleted': 'Alarma eliminada',
          'Undo': 'Deshacer',
          'The alarm has been deleted': 'La alarma ha sido eliminada'
        },
      };
}
