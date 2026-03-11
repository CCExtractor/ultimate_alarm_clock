class WorldClockModel {
  final String ianaTimezone;
  final String cityName;

  WorldClockModel({required this.ianaTimezone, required this.cityName});

  Map<String, dynamic> toJson() => {
        'ianaTimezone': ianaTimezone,
        'cityName': cityName,
      };

  factory WorldClockModel.fromJson(Map<String, dynamic> json) => WorldClockModel(
        ianaTimezone: json['ianaTimezone'] as String,
        cityName: json['cityName'] as String,
      );
}
