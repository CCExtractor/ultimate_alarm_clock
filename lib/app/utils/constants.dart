import 'package:flutter/material.dart';

enum ApiKeys {
  openWeatherMap,
}

enum AppTheme { light, dark }

enum Status { initialized, ongoing, completed }

enum WeatherTypes { sunny, cloudy, rainy, windy, stormy }

enum Difficulty { Easy, Medium, Hard }

enum WeatherKeyState { add, update, saveAdded, saveUpdated }

enum CounterUpdate { increment, decrement }

enum LocationConditionType {
  off,           
  ringWhenAt,    
  cancelWhenAt,  
  ringWhenAway,  
  cancelWhenAway 
}

enum WeatherConditionType {
  off,              
  ringWhenMatch,    
  cancelWhenMatch,  
  ringWhenDifferent,
  cancelWhenDifferent 
}

enum ActivityConditionType {
  off,             
  ringWhenActive,   
  cancelWhenActive, 
  ringWhenInactive, 
  cancelWhenInactive 
}

const Color kprimaryColor = Color(0xffAFFC41);

// Dark Theme Color Palette
const Color ksecondaryColor = Color(0xffB8E9C4);
const Color kprimaryBackgroundColor = Color(0xff16171c);
const Color ksecondaryBackgroundColor = Color(0xff1c1f26);
const Color kprimaryTextColor = Colors.white;
const Color ksecondaryTextColor = Colors.black;
const Color kprimaryDisabledTextColor = Color(0xff595f6b);

// Light Theme Color Palette
const Color kLightSecondaryColor = Color(0xff6FBC00);
const Color kLightPrimaryBackgroundColor = Color(0xffFFFFFF);
const Color kLightSecondaryBackgroundColor = Color(0xffF9F9F9);
const Color kLightPrimaryTextColor = Color(0xff444444);
const Color kLightSecondaryTextColor = Color(0xff444444);
const Color kLightPrimaryDisabledTextColor = Color(0xffACACAB);

// Dark ThemeData
ThemeData kThemeData = ThemeData(
  canvasColor: kprimaryBackgroundColor,
  useMaterial3: false,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: ksecondaryColor),
  ),
  iconTheme: const IconThemeData(
    color: kprimaryTextColor,
  ),
  fontFamily: 'poppins',
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(kprimaryTextColor),
    fillColor: MaterialStateProperty.all(kprimaryBackgroundColor),
  ),
  textTheme: const TextTheme(
    titleSmall: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
    titleMedium: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
    titleLarge: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
    bodySmall: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
    bodyMedium: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
    bodyLarge: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
    displaySmall: TextStyle(
      fontSize: 16,
      color: kprimaryTextColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    displayLarge: TextStyle(
      fontSize: 28,
      color: kprimaryTextColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    displayMedium: TextStyle(
      fontSize: 23,
      color: kprimaryTextColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: kprimaryColor,
  ),
  primaryColor: kprimaryColor,
  scaffoldBackgroundColor: kprimaryBackgroundColor,
  appBarTheme: const AppBarTheme(backgroundColor: kprimaryBackgroundColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: ksecondaryColor,
    background: kprimaryBackgroundColor,
    onPrimaryContainer: ksecondaryBackgroundColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: kprimaryTextColor.withOpacity(0.5)),
    labelStyle: const TextStyle(color: kprimaryTextColor),
    focusColor: kprimaryTextColor,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: kprimaryColor),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: kprimaryColor),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kprimaryColor,
    selectionColor: kprimaryColor,
    selectionHandleColor: ksecondaryColor,
  ),
  sliderTheme: SliderThemeData(
    thumbColor: kprimaryColor,
    activeTrackColor: kprimaryColor,
    inactiveTrackColor: kprimaryTextColor.withOpacity(0.3),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.transparent),
      side: MaterialStatePropertyAll(BorderSide(color: kprimaryColor)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: kprimaryBackgroundColor,
    selectedLabelStyle: TextStyle(
      color: kprimaryColor,
      shadows: [
        Shadow(
          color: Color.fromARGB(90, 255, 255, 255),
          offset: Offset(1, 1),
          blurRadius: 10.0,
        ),
        Shadow(
          color: Color.fromARGB(90, 255, 255, 255),
          offset: Offset(1, -1),
          blurRadius: 10.0,
        ),
        Shadow(
          color: Color.fromARGB(90, 255, 255, 255),
          offset: Offset(-1, 1),
          blurRadius: 10.0,
        ),
        Shadow(
          color: Color.fromARGB(90, 255, 255, 255),
          offset: Offset(-1, -1),
          blurRadius: 10.0,
        ),
      ],
    ),
    unselectedLabelStyle: TextStyle(
      color: kprimaryTextColor,
    ),
    selectedIconTheme: IconThemeData(
      color: kprimaryColor,

    ),
    unselectedIconTheme: IconThemeData(
      color: kprimaryTextColor,
    ),
  ),
);

// Light ThemeData
ThemeData kLightThemeData = ThemeData(
  useMaterial3: false,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: kprimaryColor),
  ),
  iconTheme: const IconThemeData(
    color: kLightPrimaryTextColor,
  ),
  fontFamily: 'poppins',
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(kprimaryTextColor),
    fillColor: MaterialStateProperty.all(kLightPrimaryBackgroundColor),
  ),
  textTheme: const TextTheme(
    titleSmall: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
    titleMedium: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
    titleLarge: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
    bodySmall: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
    bodyMedium: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
    bodyLarge: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
    displaySmall: TextStyle(
      fontSize: 16,
      color: kLightPrimaryTextColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    displayLarge: TextStyle(
      fontSize: 28,
      color: kLightPrimaryTextColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    displayMedium: TextStyle(
      fontSize: 23,
      color: kLightPrimaryTextColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: kprimaryColor,
  ),
  primaryColor: kprimaryColor,
  scaffoldBackgroundColor: kLightPrimaryBackgroundColor,
  appBarTheme: const AppBarTheme(backgroundColor: kLightPrimaryBackgroundColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kLightSecondaryColor,
    background: kLightPrimaryBackgroundColor,
    onPrimaryContainer: kLightSecondaryBackgroundColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: kLightPrimaryTextColor.withOpacity(0.5)),
    labelStyle: const TextStyle(color: kLightPrimaryTextColor),
    focusColor: kLightPrimaryTextColor,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: kprimaryColor),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: kprimaryColor),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kprimaryColor,
    selectionColor: kprimaryColor,
    selectionHandleColor: kLightSecondaryColor,
  ),
  sliderTheme: SliderThemeData(
    thumbColor: kprimaryColor,
    activeTrackColor: kprimaryColor,
    inactiveTrackColor: kLightPrimaryTextColor.withOpacity(0.3),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.transparent),
      side: MaterialStatePropertyAll(BorderSide(color: kprimaryColor)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: kLightPrimaryBackgroundColor,
    selectedLabelStyle: TextStyle(
      color: kprimaryColor,
      shadows: [
        Shadow(
          color: Color.fromARGB(120, 0, 0, 0),
          offset: Offset(1, 1),
          blurRadius: 10.0,
        ),
        Shadow(
          color: Color.fromARGB(120, 0, 0, 0),
          offset: Offset(1, -1),
          blurRadius: 10.0,
        ),
        Shadow(
          color: Color.fromARGB(120, 0, 0, 0),
          offset: Offset(-1, 1),
          blurRadius: 10.0,
        ),
        Shadow(
          color: Color.fromARGB(120, 0, 0, 0),
          offset: Offset(-1, -1),
          blurRadius: 10.0,
        ),
      ],
    ),
    unselectedLabelStyle: TextStyle(
      color: kLightPrimaryTextColor,
    ),
    selectedIconTheme: IconThemeData(
      color: kprimaryColor,
    ),
    unselectedIconTheme: IconThemeData(
      color: kLightPrimaryTextColor,
    ),
  ),
);

const List<String> defaultRingtones = ['Digital Alarm 1','Digital Alarm 2','Digital Alarm 3','Mystery','New Day'];

const Map<String, String> Holidays = {
  'Christian Holidays': 'en.christian#holiday@group.v.calendar.google.com',
  'Hindu Holidays': 'en.hinduism#holiday@group.v.calendar.google.com',
  'Jewish Holidays': 'en.judaism#holiday@group.v.calendar.google.com',
  'Muslim Holidays': 'en.islamic#holiday@group.v.calendar.google.com',
  'Afghanistan': 'en.af#holiday@group.v.calendar.google.com',
  'Albania': 'en.al#holiday@group.v.calendar.google.com',
  'Algeria': 'en.dz#holiday@group.v.calendar.google.com',
  'American Samoa': 'en.as#holiday@group.v.calendar.google.com',
  'Andorra': 'en.ad#holiday@group.v.calendar.google.com',
  'Angola': 'en.ao#holiday@group.v.calendar.google.com',
  'Anguilla': 'en.ai#holiday@group.v.calendar.google.com',
  'Antigua and Barbuda': 'en.ag#holiday@group.v.calendar.google.com',
  'Argentina': 'en.ar#holiday@group.v.calendar.google.com',
  'Armenia': 'en.am#holiday@group.v.calendar.google.com',
  'Aruba': 'en.aw#holiday@group.v.calendar.google.com',
  'Australia': 'en.australian#holiday@group.v.calendar.google.com',
  'Austria': 'en.austrian#holiday@group.v.calendar.google.com',
  'Azerbaijan': 'en.az#holiday@group.v.calendar.google.com',
  'Bahamas': 'en.bs#holiday@group.v.calendar.google.com',
  'Bahrain': 'en.bh#holiday@group.v.calendar.google.com',
  'Bangladesh': 'en.bd#holiday@group.v.calendar.google.com',
  'Barbados': 'en.bb#holiday@group.v.calendar.google.com',
  'Belarus': 'en.by#holiday@group.v.calendar.google.com',
  'Belgium': 'en.be#holiday@group.v.calendar.google.com',
  'Belize': 'en.bz#holiday@group.v.calendar.google.com',
  'Benin': 'en.bj#holiday@group.v.calendar.google.com',
  'Bermuda': 'en.bm#holiday@group.v.calendar.google.com',
  'Bhutan': 'en.bt#holiday@group.v.calendar.google.com',
  'Bolivia': 'en.bo#holiday@group.v.calendar.google.com',
  'Bosnia and Herzegovina': 'en.ba#holiday@group.v.calendar.google.com',
  'Botswana': 'en.bw#holiday@group.v.calendar.google.com',
  'Brazil': 'en.brazilian#holiday@group.v.calendar.google.com',
  'British Virgin Islands': 'en.vg#holiday@group.v.calendar.google.com',
  'Brunei Darussalam': 'en.bn#holiday@group.v.calendar.google.com',
  'Bulgaria': 'en.bulgarian#holiday@group.v.calendar.google.com',
  'Burkina Faso': 'en.bf#holiday@group.v.calendar.google.com',
  'Burundi': 'en.bi#holiday@group.v.calendar.google.com',
  'Cambodia': 'en.kh#holiday@group.v.calendar.google.com',
  'Cameroon': 'en.cm#holiday@group.v.calendar.google.com',
  'Canada': 'en.canadian#holiday@group.v.calendar.google.com',
  'Cape Verde': 'en.cv#holiday@group.v.calendar.google.com',
  'Cayman Islands': 'en.ky#holiday@group.v.calendar.google.com',
  'Central African Republic': 'en.cf#holiday@group.v.calendar.google.com',
  'Chad': 'en.td#holiday@group.v.calendar.google.com',
  'Chile': 'en.cl#holiday@group.v.calendar.google.com',
  'China': 'en.china#holiday@group.v.calendar.google.com',
  'Colombia': 'en.co#holiday@group.v.calendar.google.com',
  'Comoros': 'en.km#holiday@group.v.calendar.google.com',
  'Congo': 'en.cg#holiday@group.v.calendar.google.com',
  'Cook Islands': 'en.ck#holiday@group.v.calendar.google.com',
  'Costa Rica': 'en.cr#holiday@group.v.calendar.google.com',
  "Côte d'Ivoire": 'en.ci#holiday@group.v.calendar.google.com',
  'Croatia': 'en.croatian#holiday@group.v.calendar.google.com',
  'Cuba': 'en.cu#holiday@group.v.calendar.google.com',
  'Curaçao': 'en.cw#holiday@group.v.calendar.google.com',
  'Cyprus': 'en.cy#holiday@group.v.calendar.google.com',
  'Czechia': 'en.czech#holiday@group.v.calendar.google.com',
  "Democratic People's Republic of Korea":
      'en.kp#holiday@group.v.calendar.google.com',
  'Denmark': 'en.danish#holiday@group.v.calendar.google.com',
  'Djibouti': 'en.dj#holiday@group.v.calendar.google.com',
  'Dominica': 'en.dm#holiday@group.v.calendar.google.com',
  'Dominican Republic': 'en.do#holiday@group.v.calendar.google.com',
  'Ecuador': 'en.ec#holiday@group.v.calendar.google.com',
  'Egypt': 'en.eg#holiday@group.v.calendar.google.com',
  'El Salvador': 'en.sv#holiday@group.v.calendar.google.com',
  'Equatorial Guinea': 'en.gq#holiday@group.v.calendar.google.com',
  'Eritrea': 'en.er#holiday@group.v.calendar.google.com',
  'Estonia': 'en.ee#holiday@group.v.calendar.google.com',
  'Ethiopia': 'en.et#holiday@group.v.calendar.google.com',
  'Falkland Islands (Malvinas)': 'en.fk#holiday@group.v.calendar.google.com',
  'Faroe Islands': 'en.fo#holiday@group.v.calendar.google.com',
  'Federated States of Micronesia': 'en.fm#holiday@group.v.calendar.google.com',
  'Fiji': 'en.fj#holiday@group.v.calendar.google.com',
  'Finland': 'en.finnish#holiday@group.v.calendar.google.com',
  'France': 'en.french#holiday@group.v.calendar.google.com',
  'French Guiana': 'en.gf#holiday@group.v.calendar.google.com',
  'French Polynesia': 'en.pf#holiday@group.v.calendar.google.com',
  'Gabon': 'en.ga#holiday@group.v.calendar.google.com',
  'Gambia': 'en.gm#holiday@group.v.calendar.google.com',
  'Georgia': 'en.ge#holiday@group.v.calendar.google.com',
  'Germany': 'en.german#holiday@group.v.calendar.google.com',
  'Ghana': 'en.gh#holiday@group.v.calendar.google.com',
  'Gibraltar': 'en.gi#holiday@group.v.calendar.google.com',
  'Greece': 'en.greek#holiday@group.v.calendar.google.com',
  'Greenland': 'en.gl#holiday@group.v.calendar.google.com',
  'Grenada': 'en.gd#holiday@group.v.calendar.google.com',
  'Guam': 'en.gu#holiday@group.v.calendar.google.com',
  'Guatemala': 'en.gt#holiday@group.v.calendar.google.com',
  'Guernsey': 'en.gg#holiday@group.v.calendar.google.com',
  'Guinea': 'en.gn#holiday@group.v.calendar.google.com',
  'Guinea-Bissau': 'en.gw#holiday@group.v.calendar.google.com',
  'Guyana': 'en.gy#holiday@group.v.calendar.google.com',
  'Haiti': 'en.ht#holiday@group.v.calendar.google.com',
  'Holy See (Vatican City State)': 'en.va#holiday@group.v.calendar.google.com',
  'Honduras': 'en.hn#holiday@group.v.calendar.google.com',
  'Hong Kong': 'en.hong_kong#holiday@group.v.calendar.google.com',
  'Hungary': 'en.hungarian#holiday@group.v.calendar.google.com',
  'Iceland': 'en.is#holiday@group.v.calendar.google.com',
  'India': 'en.indian#holiday@group.v.calendar.google.com',
  'Indonesia': 'en.indonesian#holiday@group.v.calendar.google.com',
  'Iraq': 'en.iq#holiday@group.v.calendar.google.com',
  'Ireland': 'en.irish#holiday@group.v.calendar.google.com',
  'Islamic Republic of Iran': 'en.ir#holiday@group.v.calendar.google.com',
  'Isle of Man': 'en.im#holiday@group.v.calendar.google.com',
  'Israel': 'en.jewish#holiday@group.v.calendar.google.com',
  'Italy': 'en.italian#holiday@group.v.calendar.google.com',
  'Jamaica': 'en.jm#holiday@group.v.calendar.google.com',
  'Japan': 'en.japanese#holiday@group.v.calendar.google.com',
  'Jersey': 'en.je#holiday@group.v.calendar.google.com',
  'Jordan': 'en.jo#holiday@group.v.calendar.google.com',
  'Kazakhstan': 'en.kz#holiday@group.v.calendar.google.com',
  'Kenya': 'en.ke#holiday@group.v.calendar.google.com',
  'Kiribati': 'en.ki#holiday@group.v.calendar.google.com',
  'Kuwait': 'en.kw#holiday@group.v.calendar.google.com',
  'Kyrgyzstan': 'en.kg#holiday@group.v.calendar.google.com',
  "Lao People's Democratic Republic":
      'en.la#holiday@group.v.calendar.google.com',
  'Latvia': 'en.latvian#holiday@group.v.calendar.google.com',
  'Lebanon': 'en.lb#holiday@group.v.calendar.google.com',
  'Lesotho': 'en.ls#holiday@group.v.calendar.google.com',
  'Liberia': 'en.lr#holiday@group.v.calendar.google.com',
  'Libya': 'en.ly#holiday@group.v.calendar.google.com',
  'Liechtenstein': 'en.li#holiday@group.v.calendar.google.com',
  'Lithuania': 'en.lithuanian#holiday@group.v.calendar.google.com',
  'Luxembourg': 'en.lu#holiday@group.v.calendar.google.com',
  'Macao': 'en.mo#holiday@group.v.calendar.google.com',
  'Madagascar': 'en.mg#holiday@group.v.calendar.google.com',
  'Malawi': 'en.mw#holiday@group.v.calendar.google.com',
  'Malaysia': 'en.malaysia#holiday@group.v.calendar.google.com',
  'Maldives': 'en.mv#holiday@group.v.calendar.google.com',
  'Mali': 'en.ml#holiday@group.v.calendar.google.com',
  'Malta': 'en.mt#holiday@group.v.calendar.google.com',
  'Marshall Islands': 'en.mh#holiday@group.v.calendar.google.com',
  'Martinique': 'en.mq#holiday@group.v.calendar.google.com',
  'Mauritania': 'en.mr#holiday@group.v.calendar.google.com',
  'Mauritius': 'en.mu#holiday@group.v.calendar.google.com',
  'Mayotte': 'en.yt#holiday@group.v.calendar.google.com',
  'Mexico': 'en.mexican#holiday@group.v.calendar.google.com',
  'Moldova': 'en.md#holiday@group.v.calendar.google.com',
  'Monaco': 'en.mc#holiday@group.v.calendar.google.com',
  'Mongolia': 'en.mn#holiday@group.v.calendar.google.com',
  'Montenegro': 'en.me#holiday@group.v.calendar.google.com',
  'Montserrat': 'en.ms#holiday@group.v.calendar.google.com',
  'Morocco': 'en.ma#holiday@group.v.calendar.google.com',
  'Mozambique': 'en.mz#holiday@group.v.calendar.google.com',
  'Myanmar': 'en.mm#holiday@group.v.calendar.google.com',
  'Namibia': 'en.na#holiday@group.v.calendar.google.com',
  'Nauru': 'en.nr#holiday@group.v.calendar.google.com',
  'Nepal': 'en.np#holiday@group.v.calendar.google.com',
  'Netherlands': 'en.dutch#holiday@group.v.calendar.google.com',
  'New Caledonia': 'en.nc#holiday@group.v.calendar.google.com',
  'New Zealand': 'en.new_zealand#holiday@group.v.calendar.google.com',
  'Nicaragua': 'en.ni#holiday@group.v.calendar.google.com',
  'Niger': 'en.ne#holiday@group.v.calendar.google.com',
  'Nigeria': 'en.ng#holiday@group.v.calendar.google.com',
  'Northern Mariana Islands': 'en.mp#holiday@group.v.calendar.google.com',
  'Norway': 'en.norwegian#holiday@group.v.calendar.google.com',
  'Oman': 'en.om#holiday@group.v.calendar.google.com',
  'Pakistan': 'en.pk#holiday@group.v.calendar.google.com',
  'Palau': 'en.pw#holiday@group.v.calendar.google.com',
  'Panama': 'en.pa#holiday@group.v.calendar.google.com',
  'Papua New Guinea': 'en.pg#holiday@group.v.calendar.google.com',
  'Paraguay': 'en.py#holiday@group.v.calendar.google.com',
  'Peru': 'en.pe#holiday@group.v.calendar.google.com',
  'Philippines': 'en.philippines#holiday@group.v.calendar.google.com',
  'Poland': 'en.polish#holiday@group.v.calendar.google.com',
  'Portugal': 'en.portuguese#holiday@group.v.calendar.google.com',
  'Puerto Rico': 'en.pr#holiday@group.v.calendar.google.com',
  'Qatar': 'en.qa#holiday@group.v.calendar.google.com',
  'Republic of Korea': 'en.south_korea#holiday@group.v.calendar.google.com',
  'Réunion': 'en.re#holiday@group.v.calendar.google.com',
  'Romania': 'en.romanian#holiday@group.v.calendar.google.com',
  'Russian Federation': 'en.russian#holiday@group.v.calendar.google.com',
  'Rwanda': 'en.rw#holiday@group.v.calendar.google.com',
  'Saint Barthélemy': 'en.bl#holiday@group.v.calendar.google.com',
  'Saint Helena': 'en.sh#holiday@group.v.calendar.google.com',
  'Saint Kitts and Nevis': 'en.kn#holiday@group.v.calendar.google.com',
  'Saint Lucia': 'en.lc#holiday@group.v.calendar.google.com',
  'Saint Martin (French part)': 'en.mf#holiday@group.v.calendar.google.com',
  'Saint Pierre and Miquelon': 'en.pm#holiday@group.v.calendar.google.com',
  'Saint Vincent and the Grenadines':
      'en.vc#holiday@group.v.calendar.google.com',
  'Samoa': 'en.ws#holiday@group.v.calendar.google.com',
  'San Marino': 'en.sm#holiday@group.v.calendar.google.com',
  'Sao Tome and Principe': 'en.st#holiday@group.v.calendar.google.com',
  'Saudi Arabia': 'en.saudiarabian#holiday@group.v.calendar.google.com',
  'Senegal': 'en.sn#holiday@group.v.calendar.google.com',
  'Serbia': 'en.rs#holiday@group.v.calendar.google.com',
  'Seychelles': 'en.sc#holiday@group.v.calendar.google.com',
  'Sierra Leone': 'en.sl#holiday@group.v.calendar.google.com',
  'Singapore': 'en.singapore#holiday@group.v.calendar.google.com',
  'Sint Maarten (Dutch part)': 'en.sx#holiday@group.v.calendar.google.com',
  'Slovakia': 'en.slovak#holiday@group.v.calendar.google.com',
  'Slovenia': 'en.slovenian#holiday@group.v.calendar.google.com',
  'Solomon Islands': 'en.sb#holiday@group.v.calendar.google.com',
  'Somalia': 'en.so#holiday@group.v.calendar.google.com',
  'South Africa': 'en.sa#holiday@group.v.calendar.google.com',
  'South Sudan': 'en.ss#holiday@group.v.calendar.google.com',
  'Spain': 'en.spain#holiday@group.v.calendar.google.com',
  'Sri Lanka': 'en.lk#holiday@group.v.calendar.google.com',
  'Sudan': 'en.sd#holiday@group.v.calendar.google.com',
  'Suriname': 'en.sr#holiday@group.v.calendar.google.com',
  'Swaziland': 'en.sz#holiday@group.v.calendar.google.com',
  'Sweden': 'en.swedish#holiday@group.v.calendar.google.com',
  'Switzerland': 'en.ch#holiday@group.v.calendar.google.com',
  'Syrian Arab Republic': 'en.sy#holiday@group.v.calendar.google.com',
  'Taiwan': 'en.taiwan#holiday@group.v.calendar.google.com',
  'Tajikistan': 'en.tj#holiday@group.v.calendar.google.com',
  'Thailand': 'en.th#holiday@group.v.calendar.google.com',
  'The Democratic Republic of the Congo':
      'en.cd#holiday@group.v.calendar.google.com',
  'The Former Yugoslav Republic of Macedonia':
      'en.mk#holiday@group.v.calendar.google.com',
  'Timor-Leste': 'en.tl#holiday@group.v.calendar.google.com',
  'Togo': 'en.tg#holiday@group.v.calendar.google.com',
  'Tonga': 'en.to#holiday@group.v.calendar.google.com',
  'Trinidad and Tobago': 'en.tt#holiday@group.v.calendar.google.com',
  'Tunisia': 'en.tn#holiday@group.v.calendar.google.com',
  'Turkey': 'en.turkish#holiday@group.v.calendar.google.com',
  'Turkmenistan': 'en.tm#holiday@group.v.calendar.google.com',
  'Turks and Caicos Islands': 'en.tc#holiday@group.v.calendar.google.com',
  'Tuvalu': 'en.tv#holiday@group.v.calendar.google.com',
  'U.S. Virgin Islands': 'en.vi#holiday@group.v.calendar.google.com',
  'Uganda': 'en.ug#holiday@group.v.calendar.google.com',
  'Ukraine': 'en.ukrainian#holiday@group.v.calendar.google.com',
  'United Arab Emirates': 'en.ae#holiday@group.v.calendar.google.com',
  'United Kingdom': 'en.uk#holiday@group.v.calendar.google.com',
  'United Republic of Tanzania': 'en.tz#holiday@group.v.calendar.google.com',
  'United States': 'en.usa#holiday@group.v.calendar.google.com',
  'Uruguay': 'en.uy#holiday@group.v.calendar.google.com',
  'Uzbekistan': 'en.uz#holiday@group.v.calendar.google.com',
  'Vanuatu': 'en.vu#holiday@group.v.calendar.google.com',
  'Venezuela': 'en.ve#holiday@group.v.calendar.google.com',
  'Vietnam': 'en.vietnamese#holiday@group.v.calendar.google.com',
  'Wallis and Futuna': 'en.wf#holiday@group.v.calendar.google.com',
  'Yemen': 'en.ye#holiday@group.v.calendar.google.com',
  'Zambia': 'en.zm#holiday@group.v.calendar.google.com',
  'Zimbabwe': 'en.zw#holiday@group.v.calendar.google.com',
};
