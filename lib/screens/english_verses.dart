import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class VersesPage extends StatefulWidget {
  final String bookName;
  final int chapterNumber;
  final Map<String, Map<int, List<Map<String, String>>>> verses;
  final List<String> allBookNames; // Added to provide the list of all book names

  const VersesPage({
    super.key,
    required this.bookName,
    required this.chapterNumber,
    required this.verses,
    required this.allBookNames, // Accepting list of all books
  });

  @override
  State<VersesPage> createState() => _VersesPageState();
}

class _VersesPageState extends State<VersesPage> {
  List<Map<String, String>> verses = [];
  Set<String> highlightedVerses = {}; // to track highlighted verse numbers
  String selectedBook = '';
  int selectedChapter = 0;

  @override
  void initState() {
    super.initState();
    selectedBook = widget.bookName;
    selectedChapter = widget.chapterNumber;
    updateVerses();
  }

  // Function to update verses based on book and chapter selection
  void updateVerses() {
    if (widget.verses.containsKey(selectedBook) &&
        widget.verses[selectedBook]!.containsKey(selectedChapter)) {
      setState(() {
        verses = widget.verses[selectedBook]![selectedChapter]!
            .map<Map<String, String>>((v) => {
          "verse": v["verse"].toString(),
          "text": v["text"].toString()
        })
            .toList();
      });
      print("Loaded ${verses.length} verses for $selectedBook - $selectedChapter.");
    } else {
      print("No verses found for $selectedBook - $selectedChapter.");
    }
  }

  int getChapterCount(String bookName) {
    if (widget.verses.containsKey(bookName)) {
      return widget.verses[bookName]!.keys.length;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$selectedBook - Chapter $selectedChapter"),  // Update the title dynamically
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          // Dropdown to select Book
          DropdownButton<String>(
            value: selectedBook,
            onChanged: (String? newValue) {
              setState(() {
                selectedBook = newValue!;
                selectedChapter = 1; // Reset to first chapter
                updateVerses(); // Update verses when the book is changed
              });
            },
            items: widget.allBookNames
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Dropdown to select Chapter
          DropdownButton<int>(
            value: selectedChapter,
            onChanged: (int? newChapter) {
              setState(() {
                selectedChapter = newChapter!;
                updateVerses(); // Update verses when the chapter is changed
              });
            },
            items: List.generate(getChapterCount(selectedBook), (index) => index + 1)
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("Chapter $value"),
              );
            }).toList(),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                String verseNum = verses[index]["verse"].toString();
                String verseText = verses[index]["text"].toString();
                bool isHighlighted = highlightedVerses.contains(verseNum);

                return Card(
                  color: isHighlighted ? Colors.yellow.shade100 : null,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text("Verse $verseNum: $verseText"),
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
                                  Clipboard.setData(
                                    ClipboardData(text: "$verseNum. $verseText"),
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text('Share'),
                                onTap: () {
                                  String fullVerse =
                                      "${widget.bookName} ${widget.chapterNumber}:$verseNum - $verseText";
                                  Share.share(fullVerse);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.highlight),
                                title: Text(isHighlighted ? 'Remove Highlight' : 'Highlight'),
                                onTap: () {
                                  setState(() {
                                    if (isHighlighted) {
                                      highlightedVerses.remove(verseNum);
                                    } else {
                                      highlightedVerses.add(verseNum);
                                    }
                                  });
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