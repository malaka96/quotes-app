import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quotes_app/Models/quotes_model.dart';

class QuoteService {
  final CollectionReference _quotesCollection = FirebaseFirestore.instance
      .collection('quotes');

  Future<void> addQuote(String quoteText, String author) async {
    try {
      final Quote quote = Quote(
        id: "",
        quoteText: quoteText,
        author: author,
        createdAt: DateTime.now(),
      );

      final Map<String, dynamic> quoteData = quote.toJson();

      final DocumentReference docRef = await _quotesCollection.add(quoteData);
      await docRef.update({'id': docRef.id});

    } catch (error) {
      print('error adding quote $error');
    }
  }
}
