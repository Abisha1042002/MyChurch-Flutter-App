import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlipCardSection extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final VoidCallback onTap;

  const FlipCardSection({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.onTap,
  });

  @override
  State<FlipCardSection> createState() => _FlipCardSectionState();
}

class _FlipCardSectionState extends State<FlipCardSection> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool isFlipped = false; // Track flip state

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: _cardKey,
      direction: FlipDirection.HORIZONTAL,
      speed: 500,
      onFlipDone: (status) {
        setState(() {
          isFlipped = !isFlipped; // Track the state
        });
      },
      front: _buildFrontSide(),
      back: _buildBackSide(),
    );
  }

  // 📷 Front Side: Image Only
  Widget _buildFrontSide() {
    return GestureDetector(
      onTap: () {
        if (!isFlipped) {
          _cardKey.currentState?.toggleCard(); // Flip to Back
        }
      },
      child: Container(
        width: double.infinity,
        height: 180, // Bigger Card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            widget.imagePath,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // 🎵 Back Side: Title + Icon + Description + Arrow
  Widget _buildBackSide() {
    return GestureDetector(
      onTap: () {
        if (isFlipped) {
          _cardKey.currentState?.toggleCard(); // Flip Back
        }
      },
      child: Container(
        width: double.infinity,
        height: 180,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.brown[300], // Background Color
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 40, color: Colors.white), // 🔊 Icon
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 10),
        GestureDetector(
          onTap: widget.onTap, // Navigates to next page
            child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white), // ➡️ Arrow
        ),
          ],
        ),
      ),
    );
  }
}