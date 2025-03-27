import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Sothirabaligal extends StatefulWidget {
  const Sothirabaligal({super.key});

  @override
  SothirabaligalState createState() => SothirabaligalState();
}

class SothirabaligalState extends State<Sothirabaligal> {
  List<Map<String, String>> allVerses = []; // Full data
  List<Map<String, String>> displayedVerses = []; // Visible data
  int currentPage = 0;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    loadVerses();
  }

  Future<void> loadVerses() async {
    String jsonString = await rootBundle.loadString('assets/sothirabaligal.json');
    Map<String, String> jsonData = Map<String, String>.from(json.decode(jsonString));
    List<Map<String, String>> verseList = jsonData.entries.map((e) => {"id": e.key, "verse": e.value}).toList();

    setState(() {
      allVerses = verseList;
      _loadNextPage();
    });
  }

  void _loadNextPage() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (startIndex < allVerses.length) {
      setState(() {
        displayedVerses.addAll(allVerses.sublist(startIndex, endIndex > allVerses.length ? allVerses.length : endIndex));
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1000 ஸ்தோத்திரவாக்குகள்')),
      body: ListView.builder(
        itemCount: displayedVerses.length + 1, // +1 for Load More button
        itemBuilder: (context, index) {
          if (index == displayedVerses.length) {
            return displayedVerses.length < allVerses.length
                ? TextButton(
              onPressed: _loadNextPage,
              child: const Text("மேலும் காண்பிக்கவும்"),
            )
                : const SizedBox.shrink();
          }
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.volunteer_activism, color: Colors.purple), // 🙏 Icon
              title: Text("${displayedVerses[index]['id']}: ${displayedVerses[index]['verse']}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}