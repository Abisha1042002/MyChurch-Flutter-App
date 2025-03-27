import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'book_name_mapping.dart';

class VersesPage extends StatefulWidget {
  final String bookName;
  final int chapterNumber;

  const VersesPage({Key? key, required this.bookName, required this.chapterNumber}) : super(key: key);

  @override
  _VersesPageState createState() => _VersesPageState();
}

class _VersesPageState extends State<VersesPage> {
  List<Map<String, String>> verses = [];

  @override
  void initState() {
    super.initState();
    loadVerses();
  }

  Future<void> loadVerses() async {
    try {
      // Convert Tamil book name to English file name
      String englishBookName = bookNameMap[widget.bookName] ?? widget.bookName;
      String jsonPath = 'assets/Bible-tamil-main/$englishBookName.json';

      print('Loading JSON: $jsonPath');

      // Load and decode JSON file
      String jsonData = await rootBundle.loadString(jsonPath);
      Map<String, dynamic> data = json.decode(jsonData);

      // Convert chapter number to string safely
      String chapterNumberStr = widget.chapterNumber.toString();

      // Find the correct chapter
      var chapterData = data["chapters"]
          .firstWhere((chapter) => chapter["chapter"].toString() == chapterNumberStr, orElse: () => {});

      // Extract verses
      List<dynamic> versesList = chapterData["verses"] ?? [];

      setState(() {
        verses = List<Map<String, String>>.from(
          versesList.map((verse) => {
            "verse": verse["verse"].toString(),  // Ensure it's a string
            "text": verse["text"].toString(),   // Ensure it's a string
          }),
        );
      });

      print('Loaded ${verses.length} verses for Chapter ${widget.chapterNumber}');
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.bookName} - ${widget.chapterNumber}"), backgroundColor: Colors.brown),
      body: verses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: verses.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("${verses[index]["verse"]}. ${verses[index]["text"]}"),
            ),
          );
        },
      ),
    );
  }
}