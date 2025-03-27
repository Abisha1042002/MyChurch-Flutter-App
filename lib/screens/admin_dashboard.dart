import 'package:flutter/material.dart';
import 'package:my_church/screens/donation_list.dart';
import 'package:my_church/screens/events_upload.dart';
import 'package:my_church/screens/gallery_upload.dart';
import 'package:my_church/screens/marriage_events_upload.dart';
import 'package:my_church/screens/worship_videos_upload.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8E1),
        appBar: AppBar(
          backgroundColor: const Color(0xFFB8860B),
          title: Row(
            children: [
              Image.asset('assets/logo.png', width: 40, height: 50),
              const SizedBox(width: 10),
              const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(menuItems.length, (index) {
              return _buildAnimatedCard(menuItems[index], index);
            }),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildAnimatedCard(MenuItem item, int index) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      duration: Duration(milliseconds: 300 + (index * 100)), // Staggered animation
      builder: (context, offset, child) {
        return Transform.translate(offset: offset, child: child);
      },
      child: GestureDetector(
        onTap: () => _navigateWithAnimation(context, item.page),
        child: _cardContent(item),
      ),
    );
  }

  Widget _cardContent(MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        splashColor: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          height: 100,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 1)],
          ),
          child: Center(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              leading: Icon(item.icon, color: Colors.white, size: 30),
              title: Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// Menu Item Model
class MenuItem {
  final String title;
  final IconData icon;
  final Widget page;
  final Color color;

  MenuItem({required this.title, required this.icon, required this.page, required this.color});
}

// Menu Items List
final List<MenuItem> menuItems = [
  MenuItem(title: 'Events', icon: Icons.event, page: const EventUploaderPage(), color: Colors.blue.shade500),
  MenuItem(title: 'Marriage Events', icon: Icons.favorite, page: const MarriageUploaderPage(), color: Colors.green.shade500),
  MenuItem(title: 'Gallery', icon: Icons.photo_library, page: const ImageGalleryScreen(), color: Colors.purple.shade400),
  MenuItem(title: 'Worship Videos', icon: Icons.video_library, page: const VideoUploadScreen(), color: Colors.red.shade400),
  MenuItem(title: 'Donation List', icon: Icons.manage_history, page: const DonationHistoryPage(), color: Colors.teal.shade500),
];