import 'package:get/get.dart';

class RussianTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ru_RU': {
          'Alarm': 'Будильник',
          'Timer': 'Таймер',

          'Enable 24 Hour Format': 'Включить 24-часовой формат',
          'Enable Haptic Feedback': 'Включить тактильную отдачу',
          'Enable Sorted Alarm List':
              'Включить отсортированный список будильников',
          // google_sign_in.dart
          'Your account is now linked!': 'Ваш аккаунт теперь связан!',
          'Are you sure?': 'Вы уверены?',
          'unlinkAccount':
              'Вы действительно хотите отвязать свой аккаунт Google?',
          'Unlink': 'Отвязать',
          'Sign-In with Google': 'Вход с помощью Google',
          'Unlink @usermail': 'Отвязать @usermail',
          'Why do I have to sign in with Google?':
              'Почему мне нужно войти с помощью Google?',
          'Sign-inDescription':
              'Вход необязателен. Он требуется только для функций, использующих облачные службы, таких как:',
          'CollabDescription':
              'Сотрудничество с друзьями, членами семьи или коллегами, чтобы удостовериться, что они просыпаются вовремя с использованием общих будильников.',
          'Syncing Across Devices': 'Синхронизация между устройствами',
          'AccessMultiple':
              'Доступ к вашим будильникам с нескольких устройств, где будильники обновляются в реальном времени.',
          'Your privacy': 'Ваша конфиденциальность',
          'NoAccessInfo':
              'Мы не имеем доступа, не используем и не продаем никакую информацию, что вы можете проверить, изучив исходный код.',
          'LimitedAccess':
              'Весь доступ ограничен исключительно предоставлением описанных выше функций.',
          'Enable Light Mode': 'Включить светлый режим',

          'No upcoming alarms!': 'Никаких предстоящих сигналов тревоги!',
          'Next alarm': 'Следующий сигнал тревоги',
          'Show Motivational Quote': 'Показать мотивационную цитату',
          //home_view.dart
          'About': 'О',
          'Settings': 'Настройки',
          'v0.5.0': 'v0.5.0',
          'Ultimate Alarm Clock': 'Лучший будильник',
          'Create alarm': 'Создать будильник',
          'Join alarm': 'Присоединиться к будильнику',
          'Okay': 'Хорошо',
          'You cannot join your own alarm!':
              'Вы не можете присоединиться к собственной тревоге!',
          'An alarm with this ID doesn\'t exist!':
              'Тревоги с таким идентификатором не существует!',
          'Error!': 'Ошибка!',
          'Join': 'Присоединиться',
          'Enter Alarm ID': 'Введите идентификатор тревоги',
          'Join an alarm': 'присоединиться к тревоге',
          'Select alarms to delete': 'Выберите будильники для удаления',
          'No alarm selected': 'Тревога не выбрана',
          '1 alarm selected': 'Выбран 1 будильник',
          ' alarms selected': 'выбраны сигналы тревоги',
          'Add an alarm to get started!': 'Добавьте будильник, чтобы начать!',
          'Never': 'Никогда',
          'One Time': 'Один раз',
          'Preview Alarm': 'Предварительный просмотр тревоги',
          'Delete Alarm': 'Удалить сигнал тревоги',
          //about_view.dart texts
          'This project was originally developed as part of Google Summer of code under the CCExtractor organization. It\'s free, the source code is available, and we encourage programmers to contribute':
              'Этот проект изначально был разработан в рамках Google Summer of Code под руководством организации CCExtractor. Он бесплатен, исходный код доступен, и мы приглашаем программистов внести свой вклад.',
          'Could not launch': 'Не удалось запустить',
//add_or_update_alarm_view.dart
          'Discard Changes?': 'Отменить изменения?',
          'unsavedChanges':
              'У вас есть несохраненные изменения. Вы уверены, что хотите покинуть эту страницу?',
          'Cancel': 'Отмена',
          'Leave': 'Выйти',
          'Save': 'Сохранить',
          'Update': 'Обновить',
          'Rings in @timeToAlarm': 'Звонит через @timeToAlarm',
          'Uh-oh!': 'Ой-ой!',
          'alarmEditing': 'Этот будильник в настоящее время редактируется!',
          'Go back': 'Назад',
          'Automatic Cancellation': 'Автоматическая отмена',
          'Challenges': 'Задания',
          'Shared Alarm': 'Общий будильник',
//alarm_id_tile.dart
          'Success!': 'Успех!',
          'Alarm ID has been copied!': 'ID будильника скопирован!',
          'Alarm ID': 'ID будильника',
          'Disabled!': 'Отключено!',
          'toCopyAlarm':
              'Чтобы скопировать ID будильника, вам нужно включить общий будильник!',
          'Choose duration': 'Выберите продолжительность',
          'minutes': 'минут',
          'minute': 'минута',
          'Before': 'До',
          'After': 'После',
          'Ring before / after ': 'Звонить до / после',
          'Enabled': 'Включено',
          'Off': 'Выключено',
//choose_ringtone_tile.dart
          'Choose Ringtone': 'Выбрать мелодию',
          'Default': 'По умолчанию',
          'Upload Ringtone': 'Загрузить мелодию',
          'Done': 'Готово',
//label_tile.dart
          'Label': 'Метка',
          'Add a label': 'Добавить ярлык',
          'Note': 'Примечание',
          'noWhitespace':
              'Пожалуйста, не вводите пробел в качестве первого символа!',
//maths_challenge_tile.dart
          'Maths': 'Математика',
          'Math problems': 'Математические задачи',
          'mathDescription':
              'Вам нужно решать простые математические задачи выбранного уровня сложности, чтобы отключить будильник.',
          'Solve Maths questions': 'Решить математические вопросы',
          'questions': 'вопросы',
          'question': 'вопрос',
//note.dart
          'Add a note': 'Добавить заметку',
// qr_bar_code_tile.dart
          'QR/Bar Code': 'QR-код / Штрих-код',
          'qrDescription':
              'Отсканируйте QR-код / Штрих-код на любом объекте, например, на книге, и переместите его в другую комнату. Чтобы отключить будильник, просто повторно отсканируйте тот же QR-код / Штрих-код.',
//repeat_once_tile.dart
          'Repeat only once': 'Повторять только один раз',
//repeat_tile.dart
          'Repeat': 'Повторить',
          'Days of the week': 'Дни недели',
          'Monday': 'Понедельник', 'Tuesday': 'Вторник', 'Wednesday': 'Среда',
          'Thursday': 'Четверг', 'Friday': 'Пятница', 'Saturday': 'Суббота',
          'Sunday': 'Воскресенье',
//screen_activity_tile.dart
          'Timeout Duration': 'Длительность тайм-аута',
          'Screen Activity': 'Активность экрана',
          'Screen activity based cancellation':
              'Отмена на основе активности экрана',
          'screenDescription':
              'Эта функция автоматически отменяет будильник, если вы используете свое устройство в течение установленного количества минут.',
//shake_to_dismiss_tile.dart
          'Shake to dismiss': 'Встряхнуть для отклонения',
          'shakeDescription':
              'Вам нужно встряхнуть телефон установленное количество раз, чтобы отклонить будильник - больше ленивого откладывания :)',
          'Number of shakes': 'Количество встряхиваний',
          'times': 'раз',
          'time': 'раз',
//'shared_alarm_tile.dart
          'Shared Alarm': 'Общий будильник',
          'Shared alarms': 'Общие будильники',
          'sharedDescription':
              'Делитесь будильниками с другими, используя ID будильника. Каждый общий пользователь может выбрать, звонить ли его будильнику до или после установленного времени.',
          'Understood': 'Понял',
          'To use this feature, you have to link your Google account!':
              'Чтобы использовать эту функцию, вы должны связать свою учетную запись Google!',
          'Go to settings': 'Перейти к настройкам',
          'Enable Shared Alarm': 'Включить общий будильник',
//shared_users_tile.dart
          'Alarm Owner': 'Владелец будильника',
          'Shared Users': 'Общие пользователи',
          'No shared users!': 'Нет общих пользователей!',
          'Remove': 'Удалить',
          'Select duration': 'Выберите продолжительность',
//snooze_duration_tile.dart
          'Snooze Duration': 'Длительность отложенного сна',
//weather_tile.dart
          'Select weather types': 'Выберите типы погоды',
          'Sunny': 'Солнечно',
          'Cloudy': 'Облачно',
          'Rainy': 'Дождливо',
          'Windy': 'Ветрено',
          'Stormy': 'Грозово',
          'Weather Condition': 'Погодные условия',
          'Weather based cancellation': 'Отмена на основе погоды',
          'weatherDescription':
              'Эта функция автоматически отменяет будильник, если текущая погода соответствует вашим выбранным погодным условиям, что позволяет вам спать лучше!',
          'To use this feature, you have to add an OpenWeatherMap API key!':
              'Чтобы использовать эту функцию, вы должны добавить ключ API от OpenWeatherMap!',
//alarm_challenge_view.dart
          'Shake Challenge': 'Задание на встряхивание',
          'Maths Challenge': 'Математическое задание',
          'QR/Bar Code Challenge': 'Задание на QR-код / Штрих-код',
//maths_challenge_view.dart
          'Question @noMathQ': 'Вопрос @noMathQ',
//qr_challenge_view.dart
          'Scan your QR/Bar Code!': 'Отсканируйте свой QR-код / Штрих-код!',
          'Wrong Code Scanned!': 'Неправильный код отсканирован!',
          'Retake': 'Повторить',
//shake_challenge_view.dart
          'Shake your phone!': 'Встряхните свой телефон!',
//alarm_ring_view.dart
          "You can't go back while the alarm is ringing":
              "Вы не можете вернуться, пока звонит будильник",
          'Start Challenge': 'Начать задание',
          'Dismiss': 'Отклонить',
          'Exit Preview': 'Выйти из предпросмотра',
          'Snooze': 'Отложить',
          //utils.dart
          'Location Based': 'На основе местоположения',
          'Everyday': 'Каждый день',
          'Weekdays': 'Будние дни',
          'Weekends': 'Выходные',
          'Mon': 'Пн', 'Tue': 'Вт', 'Wed': 'Ср', 'Thur': 'Чт',
          'Fri': 'Пт', 'Sat': 'Сб', 'Sun': 'Вс',
          //OpenWeatherMap
          'onenweathermap_title1.1': 'Шаги, чтобы получить ',
          'onenweathermap_title1.2': 'OpenWeatherMap API',
          'step1.1': 'Идти к ',
          'step1.2': 'openweathermap.org',
          'step1.3': ', нажмите на кнопку ',
          'step1.4': 'SignIn',
          'step1.5':
              ' (в правом верхнем углу) затем он запрашивает учетные данные для входа.',
          'step2.1':
              'Если у вас уже есть учетная запись, введите свои учетные данные. В противном случае нажмите на опцию ',
          'step2.2': 'Create an Account',
          'step2.3':
              ' . Он просит вас ввести имя пользователя, адрес электронной почты и пароль. Убедитесь, что введенные данные верны.',
          'step3':
              'Как только ваша учетная запись будет создана, вы автоматически будете перенаправлены на страницу OpenWeather. Он спрашивает вас о вашей компании и цели использования платформы., заполните эти данные соответствующим образом.',
          'step4.1': 'Нажмите на ',
          'step4.2': 'Username',
          'step4.3':
              '(в правом верхнем углу). Появится раскрывающееся меню. Нажмите на опцию ',
          'step4.4': 'My API',
          'step4.5': '.',
          'step5': 'Теперь у вас есть API. Выберите ключ и скопируйте его.',
          //ascending_volume.dart
          'Volume will reach maximum in': 'Объем достигнет максимума через',
          'seconds': 'секунды',
          'Adjust the volume range:': 'Отрегулируйте диапазон громкости:',
          'Apply Gradient': 'Применить градиент',
          'Ascending Volume': 'Восходящий объем',
        },
      };
}
