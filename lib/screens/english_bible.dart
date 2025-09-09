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
  List<String> allBookNames = [];
  Map<String, Map<int, List<Map<String, String>>>> structuredVerses = {};

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final String response = await rootBundle.loadString('assets/AKJV.json');
      final Map<String, dynamic> data = json.decode(response);

      List<dynamic> allBooksRaw = data["books"]; // List of books
      List<Map<String, dynamic>> allBooks =
      allBooksRaw.map((e) => Map<String, dynamic>.from(e)).toList();

      allBookNames = allBooks.map<String>((book) => book["name"].toString()).toList();

      for (var book in allBooks) {
        String bookName = book["name"];
        List<dynamic> chapters = book["chapters"];

        Map<int, List<Map<String, String>>> chapterMap = {};

        for (var chapter in chapters) {
          int chapterNumber = chapter["chapter"];
          List<dynamic> versesList = chapter["verses"];

          List<Map<String, String>> parsedVerses = versesList.map<Map<String, String>>((verse) {
            return {
              "verse": verse["verse"].toString(),
              "text": verse["text"].toString(),
            };
          }).toList();

          chapterMap[chapterNumber] = parsedVerses;
        }

        structuredVerses[bookName] = chapterMap;
      }

      setState(() {
        oldTestament = allBooks.sublist(0, 39);
        newTestament = allBooks.sublist(39);
      });
    } catch (e) {
      print("❌ Error loading Bible JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 English Bible"),
        backgroundColor: Colors.brown,
      ),
      body: oldTestament.isEmpty && newTestament.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Row(
        children: [
          Expanded(
            child: _buildBookList(
              context,
              oldTestament,
              "📖 Old Testament",
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.grey),
          Expanded(
            child: _buildBookList(
              context,
              newTestament,
              "📖 New Testament",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(
      BuildContext context, List<Map<String, dynamic>> books, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
                  title: Text(
                    "$bookName ($chapterCount Chapters)",
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChaptersPage(
                          bookName: bookName,
                          chapters: books[index]["chapters"],
                          allBookNames: allBookNames,
                          structuredVerses: structuredVerses, // Pass structuredVerses here
                        ),
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