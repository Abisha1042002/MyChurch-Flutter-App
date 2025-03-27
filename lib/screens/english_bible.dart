import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'english_chapters.dart';

class EnglishBibleBooksPage extends StatefulWidget {
  const EnglishBibleBooksPage({super.key});

  @override
  EnglishBibleBooksPageState createState() => EnglishBibleBooksPageState();
}

class EnglishBibleBooksPageState extends State<EnglishBibleBooksPage> {
  List<Map<String, dynamic>> oldTestament = [];
  List<Map<String, dynamic>> newTestament = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final String response = await rootBundle.loadString('assets/AKJV.json');
    final Map<String, dynamic> data = json.decode(response);

    List<Map<String, dynamic>> allBooks = List<Map<String, dynamic>>.from(data["books"]);

    setState(() {
      oldTestament = allBooks.sublist(0, 39); // First 39 books are Old Testament
      newTestament = allBooks.sublist(39); // Remaining books are New Testament
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📖 English Bible"), backgroundColor: Colors.brown),
      body: Row(
        children: [
          Expanded(child: _buildBookList(context, oldTestament, "📖 Old  Testament")),
          const VerticalDivider(width: 1, color: Colors.grey), // Divider between sections
          Expanded(child: _buildBookList(context, newTestament, "📖 New Testament")),
        ],
      ),
    );
  }

  Widget _buildBookList(BuildContext context, List<Map<String, dynamic>> books, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              String bookName = books[index]["name"];
              int chapterCount = books[index]["chapters"].length;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  title: Text("$bookName ($chapterCount Chapters)", textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChaptersPage(bookName: bookName, chapters: books[index]["chapters"]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}