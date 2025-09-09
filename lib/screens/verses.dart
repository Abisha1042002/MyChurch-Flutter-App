import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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
  Set<String> highlightedVerses = {}; // Track highlighted verses
  String selectedBook = '';
  int selectedChapter = 0;
  int chapterCount = 0;

  @override
  void initState() {
    super.initState();
    selectedBook = widget.bookName;
    selectedChapter = widget.chapterNumber;
    loadVerses();
  }

  Future<void> loadVerses() async {
    try {
      String englishBookName = bookNameMap[selectedBook] ?? selectedBook;
      String jsonPath = 'assets/Bible-tamil-main/$englishBookName.json';

      String jsonData = await rootBundle.loadString(jsonPath);
      Map<String, dynamic> data = json.decode(jsonData);

      // Get total chapters count
      chapterCount = data["chapters"]?.length ?? 0;

      // Validate selectedChapter value
      if (selectedChapter > chapterCount) {
        selectedChapter = 1;
      }

      String chapterNumberStr = selectedChapter.toString();

      var chapterData = data["chapters"]
          .firstWhere((chapter) => chapter["chapter"].toString() == chapterNumberStr, orElse: () => {});

      List<dynamic> versesList = chapterData["verses"] ?? [];

      setState(() {
        verses = List<Map<String, String>>.from(
          versesList.map((verse) => {
            "verse": verse["verse"].toString(),
            "text": verse["text"].toString(),
          }),
        );
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$selectedBook - $selectedChapter"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadVerses();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown to select Book
          DropdownButton<String>(
            value: selectedBook,
            onChanged: (String? newValue) {
              setState(() {
                selectedBook = newValue!;
                loadVerses();
              });
            },
            items: bookNameMap.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          DropdownButton<int>(
            value: selectedChapter,
            onChanged: (int? newChapter) {
              setState(() {
                selectedChapter = newChapter!;
                loadVerses();
              });
            },
            items: List.generate(chapterCount, (index) => index + 1).map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("Chapter $value"),
              );
            }).toList(),
          ),

          // Show verses
          Expanded(
            child: verses.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                String verseNum = verses[index]["verse"]!;
                String verseText = verses[index]["text"]!;
                bool isHighlighted = highlightedVerses.contains(verseNum); // Check if this verse is highlighted
                return Card(
                  color: isHighlighted ? Colors.yellow.shade100 : null, // Highlight color
                  child: ListTile(
                    title: Text("$verseNum. $verseText"),
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.copy),
                                title: Text('Copy'),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: "$verseNum. $verseText"));
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text('Share'),
                                onTap: () {
                                  String fullVerse = "$selectedBook $selectedChapter:$verseNum - $verseText";
                                  Share.share(fullVerse);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.highlight),
                                title: Text('Highlight'),
                                onTap: () {
                                  setState(() {
                                    if (isHighlighted) {
                                      highlightedVerses.remove(verseNum); // Remove highlight
                                    } else {
                                      highlightedVerses.add(verseNum); // Add highlight
                                    }
                                  });// Add functionality to highlight verses if required
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}