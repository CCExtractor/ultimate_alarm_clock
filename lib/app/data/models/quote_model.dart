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

  Quote.fromMap(Map map)
      : quote = map['quote'],
        author = map['author'];
}
