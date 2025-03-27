import 'package:flutter/material.dart';
import 'package:my_church/screens/bible.dart';
import 'package:my_church/screens/english_bible.dart';

class BibleSelection extends StatelessWidget {
  const BibleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bible.png', // Background image
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.3),
            colorBlendMode: BlendMode.lighten,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BibleCard(
                  title: '📖 Tamil Bible',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BibleBooksPage()),
                  ),
                ),
                const SizedBox(height: 30),
                BibleCard(
                  title: '📖 English Bible',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EnglishBibleBooksPage()),
                  ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BibleCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const BibleCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.redAccent.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}