import 'package:flutter/material.dart';
import 'english_verses.dart';

class ChaptersPage extends StatelessWidget {
  final String bookName;
  final List<dynamic> chapters; // List of chapters for this book

  const ChaptersPage({super.key, required this.bookName, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName), backgroundColor: Colors.brown),
      body: ListView.builder( // 🔹 Each chapter in a separate row
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          int chapterNumber = chapters[index]["chapter"];
          return Card( // 🔹 Wrap each chapter inside a card
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4, // 🔹 Adds shadow for better look
            child: ListTile(
              title: Text(
                "Chapter $chapterNumber",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersesPage(
                      bookName: bookName,
                      chapterNumber: chapterNumber,
                      verses: chapters[index]["verses"],
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