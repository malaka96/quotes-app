import 'package:flutter/material.dart';
import 'package:quotes_app/services/quote_service.dart';
import 'package:quotes_app/Models/quotes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Set<String> favoriteQuoteIds = {};

  @override
  void dispose() {
    super.dispose();
    _quoteController.dispose();
    _authorController.dispose();
  }

  void _showAddQuoteBottomSheet() {
    _quoteController.clear();
    _authorController.clear();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Text(
                  'Add a Quote',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _quoteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter quote text',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    hintText: 'Enter author name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Handle adding the quote
                    if (_quoteController.text.isEmpty ||
                        _authorController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Missing Information'),
                            content: Text('Please fill in both fields'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    await QuoteService().addQuote(
                      _quoteController.text,
                      _authorController.text,
                    );
                    _quoteController.clear();
                    _authorController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('Add Quote'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quotes App')),
      body: StreamBuilder(
        stream: QuoteService().getQuotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error Loading Quotes ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quotes available'));
          } else {
            final List<Quote> quotes = snapshot.data!;
            quotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final Quote quote = quotes[index];
                final isFavorite = favoriteQuoteIds.contains(quote.id);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(quote.quoteText),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Author : ${quote.author}'),
                          Text('Created At : ${quote.createdAt}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favoriteQuoteIds.remove(quote.id);
                            } else {
                              favoriteQuoteIds.add(quote.id);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuoteBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
