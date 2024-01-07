import 'dart:convert';
import 'package:http/http.dart' as http;

import 'quote_model.dart'; // Import the Quote class

class ApiClient {
  Future<Quote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      return Quote.fromJson(json[0]);
    } else {
      throw Exception('Failed to fetch quote');
    }
  }
}
