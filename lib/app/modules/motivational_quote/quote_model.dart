import 'api_client.dart'; // Import the ApiClient class
class Quote {
  final String quoteText;
  final String author;

  Quote({required this.quoteText, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quoteText: json['q'],
      author: json['a'],
    );
  }
}