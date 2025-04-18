class SystemRingtone {
  final String title;
  final String uri;
  final String category; // 'alarm', 'notification', or 'ringtone'

  SystemRingtone({
    required this.title,
    required this.uri,
    required this.category,
  });

  factory SystemRingtone.fromJson(Map<dynamic, dynamic> json) {
    return SystemRingtone(
      title: json['title'].toString(),
      uri: json['uri'].toString(),
      category: json['category'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'uri': uri,
      'category': category,
    };
  }
} 