import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verses.dart';
import 'book_name_mapping.dart';

class ChaptersPage extends StatefulWidget {
  final String bookName;

  const ChaptersPage({Key? key, required this.bookName}) : super(key: key);

  @override
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  int totalChapters = 0;

  @override
  void initState() {
    super.initState();
    loadChapters();
  }

  Future<void> loadChapters() async {
    try {
      // Convert Tamil book name to English file name
      String englishBookName = bookNameMap[widget.bookName] ?? widget.bookName;
      String jsonPath = 'assets/Bible-tamil-main/$englishBookName.json';

      print('Loading JSON: $jsonPath');

      // Load and decode JSON file
      String jsonData = await rootBundle.loadString(jsonPath);
      Map<String, dynamic> data = json.decode(jsonData);

      // Convert `count` to an integer safely
      setState(() {
        totalChapters = int.tryParse(data["count"].toString()) ?? 0;
      });

      print('Loaded successfully: $englishBookName.json, Chapters: $totalChapters');
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookName), backgroundColor: Colors.brown),
      body: totalChapters == 0
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: totalChapters,
        itemBuilder: (context, index) {
          int chapter = index + 1;
          return Card(
            child: ListTile(
              title: Text("அதிகாரம் $chapter"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersesPage(bookName: widget.bookName, chapterNumber: chapter),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}