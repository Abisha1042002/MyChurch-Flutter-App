import 'package:flutter/material.dart';

class NotificationPreferenceScreen extends StatefulWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  State<NotificationPreferenceScreen> createState() => _NotificationPreferenceScreenState();
}

class _NotificationPreferenceScreenState extends State<NotificationPreferenceScreen> {
  bool announcementNotif = true;
  bool donationNotif = true;
  bool eventNotif = false;
  bool bibleVerseNotif = true;
  bool sermonNotif = true;

  void _savePreferences() {
    // You can store these in Firestore or SharedPreferences if needed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notification preferences saved successfully!")),
    );
    Navigator.pop(context);
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blueGrey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Preferences"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchTile("Church Announcements", announcementNotif, (val) {
            setState(() => announcementNotif = val);
          }),
          _buildSwitchTile("Donation Updates", donationNotif, (val) {
            setState(() => donationNotif = val);
          }),
          _buildSwitchTile("Event Reminders", eventNotif, (val) {
            setState(() => eventNotif = val);
          }),
          _buildSwitchTile("Daily Bible Verses", bibleVerseNotif, (val) {
            setState(() => bibleVerseNotif = val);
          }),
          _buildSwitchTile("Sermon Notifications", sermonNotif, (val) {
            setState(() => sermonNotif = val);
          }),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _savePreferences,
            icon: const Icon(Icons.save),
            label: const Text("Save Preferences"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          )
        ],
      ),
    );
  }
}