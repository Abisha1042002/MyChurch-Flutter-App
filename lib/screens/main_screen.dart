import 'package:flutter/material.dart';
import 'package:my_church/screens/bible_selection.dart';
import 'package:my_church/screens/church_accordion.dart';
import 'package:my_church/screens/donation_screen.dart';
import 'package:my_church/screens/gallery.dart';
import 'package:my_church/screens/shopping_home_page.dart';
import 'package:my_church/screens/songs.dart';
import 'package:my_church/screens/sothira_baligal.dart';
import 'package:my_church/screens/user_login_page.dart';
import 'package:my_church/screens/worship_videos.dart';
import 'admin_login_page.dart';
import 'flipcard.dart';
import 'package:my_church/screens/account_create.dart';
import 'package:my_church/screens/profile_details.dart';
import 'package:my_church/screens/account_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_church/screens/login_selection.dart';

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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // 🪄 Open Drawer
              },
            );
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
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
                MaterialPageRoute(builder: (context) => const Sothirabaligal()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_book, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BibleSelection()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFF8E1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFB8860B),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                ),
              ),
              child: const ProfileRowWidget(),
            ),
            const SizedBox(height: 20),
            buildDrawerItem(
              icon: Icons.person_outline,
              text: 'My Account',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
              },
            ),
            buildDrawerItem(
              icon: Icons.shopping_bag_outlined,
              text: 'Shopping',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            buildDrawerItem(
              icon: Icons.volunteer_activism,
              text: 'Donations',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonationPage()),
                );
              },
            ),
            const Spacer(),
            const Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            buildDrawerItem(
              icon: Icons.manage_accounts,
              text: 'Account settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLoginPage()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
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
            ),
          ],
        ),
      ),
    );
  }

  // Function to build Drawer items
  Widget buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB8860B)),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.amber.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}