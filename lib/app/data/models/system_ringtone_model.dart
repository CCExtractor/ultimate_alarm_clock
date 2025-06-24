class SystemRingtoneModel {
  final String title;
  final String uri;
  final String id;
  final String category;

  SystemRingtoneModel({
    required this.title,
    required this.uri,
    required this.id,
    required this.category,
  });

  factory SystemRingtoneModel.fromMap(Map<String, dynamic> map) {
    return SystemRingtoneModel(
      title: map['title'] ?? '',
      uri: map['uri'] ?? '',
      id: map['id'] ?? '',
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'uri': uri,
      'id': id,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'SystemRingtoneModel{title: $title, uri: $uri, id: $id, category: $category}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SystemRingtoneModel &&
        other.title == title &&
        other.uri == uri &&
        other.id == id &&
        other.category == category;
  }

  @override
  int get hashCode {
    return title.hashCode ^ uri.hashCode ^ id.hashCode ^ category.hashCode;
  }
} 