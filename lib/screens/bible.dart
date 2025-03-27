import 'package:flutter/material.dart';
import 'chapters.dart';

class BibleBooksPage extends StatelessWidget {
  const BibleBooksPage({super.key});

  // ✅ Full Old Testament Books List (பழைய ஏற்பாடு)
  static const List<String> oldTestament = [
    "ஆதியாகமம்", "யாத்திராகமம்", "லேவியராகமம்", "எண்ணாகமம்", "உபாகமம்",
    "யோசுவா", "நியாயாதிபதிகள்", "ரூத்", "1 சாமுவேல்", "2 சாமுவேல்",
    "1 இராஜாக்கள்", "2 இராஜாக்கள்", "1 நாளாகமம்", "2 நாளாகமம்",
    "எஸ்றா", "நெகேமியா", "எஸ்தேர்", "யோபு", "சங்கீதம்", "நீதி மொழிகள்",
    "பிரசங்கி", "உன்னதப்பாட்டு", "எசாயா", "எரேமியா", "புலம்பல்",
    "எசேக்கியேல்", "தானியேல்", "ஓசியா", "யோவேல்", "ஆமோஸ்", "ஒபதியா",
    "யோனா", "மீக்கா", "நாகூம்", "ஆபக்கூக்", "செப்பனியா", "ஆகாய்",
    "சகரியா", "மால்கியா"
  ];

  // ✅ Full New Testament Books List (புதிய ஏற்பாடு)
  static const List<String> newTestament = [
    "மத்தேயு", "மாற்கு", "லூக்கா", "யோவான்", "திருத்தூதர் நிகழ்கள்",
    "ரோமர்", "1 கொரிந்தியர்", "2 கொரிந்தியர்", "கலாத்தியர்", "எபேசியர்",
    "பிலிப்பியர்", "கொலோசெயர்", "1 தெசலோனிக்கியர்", "2 தெசலோனிக்கியர்",
    "1 தீமோத்தேயு", "2 தீமோத்தேயு", "தீத்து", "பிலேமோன்", "எபிரேயர்",
    "யாக்கோபு", "1 பேதுரு", "2 பேதுரு", "1 யோவான்", "2 யோவான்", "3 யோவான்",
    "யூதா", "வெளிப்படுத்தல்"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("   📖 Tamil Bible"), backgroundColor: Colors.brown),
      body: Row(
        children: [
          Expanded(child: _buildBookList(context, oldTestament, " 📖 பழைய ஏற்பாடு")),
          Expanded(child: _buildBookList(context, newTestament, " 📖 புதிய ஏற்பாடு")),
        ],
      ),
    );
  }

  Widget _buildBookList(BuildContext context, List<String> books, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, textAlign: TextAlign.center,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  title: Text(books[index], textAlign: TextAlign.center,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChaptersPage(bookName: books[index]),
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