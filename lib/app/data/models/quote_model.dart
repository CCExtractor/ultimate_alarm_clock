class Quote {
  String quote;
  String author;

  Quote({
    required this.quote,
    required this.author,
  });

  String getQuote() {
    return quote;
  }

  String getAuthor() {
    return author;
  }

  Quote.fromMap(Map json)
      : quote = json['quote'],
        author = json['author'];
}
