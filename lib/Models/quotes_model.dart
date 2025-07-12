import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  String id;
  String quoteText;
  String author;
  DateTime createdAt;

  Quote({
    required this.id,
    required this.quoteText,
    required this.author,
    required this.createdAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json, String id) {
    return Quote(
      id: id,
      quoteText: json['quote'] as String,
      author: json['author'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': quoteText,
      'author': author,
      'createdAt': createdAt,
    };
  }
}
