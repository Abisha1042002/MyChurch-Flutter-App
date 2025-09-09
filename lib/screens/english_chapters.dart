import 'package:flutter/material.dart';
import 'english_verses.dart'; // Ensure this import is correct

class ChaptersPage extends StatelessWidget {
  final String bookName;
  final List<dynamic> chapters; // List of chapters for this book
  final List<String> allBookNames; // List of all book names
  final Map<String, Map<int, List<Map<String, String>>>> structuredVerses;
  const ChaptersPage({
    super.key,
    required this.bookName,
    required this.chapters,
    required this.allBookNames,
    required this.structuredVerses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName), backgroundColor: Colors.brown),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          int chapterNumber = chapters[index]["chapter"];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4, // Adds shadow for a better look
            child: ListTile(
              title: Text(
                "Chapter $chapterNumber",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Pass structuredVerses to the VersesPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersesPage(
                      bookName: bookName,
                      chapterNumber: chapterNumber,
                      verses: structuredVerses, // Use structuredVerses here
                      allBookNames: allBookNames, // Pass it here
                    ),
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