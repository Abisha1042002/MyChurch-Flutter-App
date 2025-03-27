import 'package:flutter/material.dart';
import 'package:my_church/screens/bible_selection.dart';
import 'package:my_church/screens/church_accordion.dart';
import 'package:my_church/screens/gallery.dart';
import 'package:my_church/screens/songs.dart';
import 'package:my_church/screens/sothira_baligal.dart';
import 'package:my_church/screens/user_login_page.dart';
import 'package:my_church/screens/worship_videos.dart';
import 'admin_login_page.dart';
import 'flipcard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 30),
            const Text(
              'My Church',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.article, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Sothirabaligal()), // Change to your Bible page
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BibleSelection()), // Change to your Bible page
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.person, color: Colors.white),
            onSelected: (String value) {
              if (value == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminLoginPage()),
                );
              } else if (value == 'user') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'admin',
                  child: Text('Admin login'),
                ),
                const PopupMenuItem<String>(
                  value: 'user',
                  child: Text('User Login'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/csi-st-thomas-church-10292362.png',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'I am the way, the truth, and the life. No one comes to the Father except through me.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.blueGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'John 14:6',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: double.infinity,
              child: ChurchAccordion(),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                FlipCardSection(
                  title: "Songs",
                  description: "Listen to worship songs and hymns.",
                  imagePath: "assets/songs.png",
                  icon: Icons.music_note,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SongListPage()));
                  },
                ),
                const SizedBox(height: 20),
                FlipCardSection(
                  title: "Gallery",
                  description: "View church event photos and memories.",
                  imagePath: "assets/gallery.png",
                  icon: Icons.photo_album,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageGalleryScreen()));
                  },
                ),
                const SizedBox(height: 20),
                FlipCardSection(
                  title: "Videos",
                  description: "Watch church sermons and events.",
                  imagePath: "assets/video.png",
                  icon: Icons.video_library,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoListScreen()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  }