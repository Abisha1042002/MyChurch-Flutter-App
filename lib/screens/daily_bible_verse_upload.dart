import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleVerseWidget extends StatefulWidget {
  const BibleVerseWidget({super.key});

  @override
  BibleVerseWidgetState createState() => BibleVerseWidgetState();
}

class BibleVerseWidgetState extends State<BibleVerseWidget> {
  String verse = "Loading...";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _uploadVersesToFirestore(); // Upload JSON data to Firestore (Only runs once)
    _checkAndUpdateDailyVerse();
  }

  Future<void> _uploadVersesToFirestore() async {
    QuerySnapshot snapshot = await _firestore.collection("verses").get();

    // Check if verses already exist
    if (snapshot.docs.isNotEmpty) return;

    List<String> bibleFiles = ["Mark.json", "Genesis.json", "Psalms.json", "John.json"];

    for (String file in bibleFiles) {
      String jsonString = await rootBundle.loadString('assets/Bible-tamil-main/$file');
      Map<String, dynamic> bibleData = jsonDecode(jsonString);
      List<dynamic> chapters = bibleData['chapters'];

      // ✅ Use Tamil book name
      String bookNameTamil = bibleData['book']['tamil'] ?? bibleData['book']['english'];

      for (var chapter in chapters) {
        List<dynamic> verses = chapter['verses'];
        for (var verse in verses) {
          await _firestore.collection("verses").add({
            'book': bookNameTamil,
            'chapter': int.tryParse(chapter['chapter'].toString()) ?? 0,
            'verse': int.tryParse(verse['verse'].toString()) ?? 0,
            'text': verse['text'],
          });
        }
      }
    }
  }

  Future<void> _checkAndUpdateDailyVerse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastShownDate = prefs.getString("lastShownDate");
    String? storedVerse = prefs.getString("dailyVerse");
    String today = DateTime.now().toIso8601String().split("T")[0];

    if (lastShownDate == null || lastShownDate != today || storedVerse == null) {
      QuerySnapshot snapshot = await _firestore.collection("verses").get();

      if (snapshot.docs.isNotEmpty) {
        var randomVerse = snapshot.docs[DateTime.now().millisecondsSinceEpoch % snapshot.docs.length];
        Map<String, dynamic> newVerse = randomVerse.data() as Map<String, dynamic>;

        String formattedVerse =
            "📖 ${newVerse['book']} ${newVerse['chapter']}:${newVerse['verse']}\n\n\"${newVerse['text']}\"";

        await prefs.setString("lastShownDate", today);
        await prefs.setString("dailyVerse", formattedVerse);

        setState(() {
          verse = formattedVerse;
        });
      } else {
        setState(() {
          verse = "No verses found!";
        });
      }
    } else {
      setState(() {
        verse = storedVerse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      verse,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,),
    );
  }
}