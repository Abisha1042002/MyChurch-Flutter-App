import 'package:flutter/material.dart';

class VersesPage extends StatelessWidget {
  final String bookName;
  final int chapterNumber;
  final List<dynamic> verses;

  const VersesPage({
    super.key,
    required this.bookName,
    required this.chapterNumber,
    required this.verses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$bookName - Chapter $chapterNumber"), backgroundColor: Colors.brown),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text("Verse ${verses[index]["verse"]}: ${verses[index]["text"]}"),
            ),
          );
        },
      ),
    );
  }
}