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
        likeCount: 0,
        createdAt: DateTime.now(),
      );

      final Map<String, dynamic> quoteData = quote.toJson();

      final DocumentReference docRef = await _quotesCollection.add(quoteData);
      await docRef.update({'id': docRef.id});
    } catch (error) {
      print('error adding quote $error');
    }
  }

  Future<void> toggleLike(String quoteId, String userId, bool isLiked) async {
    final docRef = _quotesCollection.doc(quoteId);

    if (isLiked) {
      await docRef.update({
        'likeCount': FieldValue.increment(-1),
        //'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'likeCount': FieldValue.increment(1),
        //'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<List<Quote>> getQuotes() {
    return _quotesCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => Quote.fromJson(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList(),
    );
  }
}
