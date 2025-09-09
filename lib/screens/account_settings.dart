import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_church/screens/two_factor_authentication.dart';
import 'package:my_church/screens/security_questions.dart';
import 'package:my_church/screens/notification_preference.dart';
import 'package:my_church/screens/contact_support.dart';
import 'package:my_church/screens/report_problem.dart';
import 'package:my_church/screens/delete_account.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  AccountSettingsPageState createState() => AccountSettingsPageState();
}

class AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Section
            const Text(
              'Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildSettingsItem(
              icon: Icons.security,
              title: 'Enable Two-Factor Authentication',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? email = prefs.getString("email");

                if (email != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Enable2FAScreen(userEmail: email),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email not found. Please login again.")),
                  );
                }// Handle 2FA logic here
              },
            ),
            const SizedBox(height: 10),
            _buildSettingsItem(
              icon: Icons.security,
              title: 'Security Questions',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? email = prefs.getString("email");

                if (email != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecurityQuestionsScreen(userEmail: email),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email not found. Please login again.")),
                  );
                }// Handle security question setup here
              },
            ),
            const Divider(),
            // Privacy Section
            const Text(
              'Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildSettingsItem(
              icon: Icons.notifications,
              title: 'Notification Preferences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPreferenceScreen(),
                  ),
                );// Handle notification preferences here
              },
            ),
            const Divider(),
            // Support Section
            const Text(
              'Support & Help',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildSettingsItem(
              icon: Icons.chat_bubble_outline,
              title: 'Contact Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                );// Handle contact support here
              },
            ),
            const SizedBox(height: 10),
            _buildSettingsItem(
              icon: Icons.report_problem,
              title: 'Report a Problem',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserReportProblemScreen()),
                );// Handle report a problem here
              },
            ),
            const Divider(),
            // Logout Section
            _buildSettingsItem(
              icon: Icons.exit_to_app,
              title: 'Delete Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeleteAccountScreen()),
                );// Handle delete account logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB8860B)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
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