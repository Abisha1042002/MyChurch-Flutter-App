import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  EventListPageState createState() => EventListPageState();
}

class EventListPageState extends State<EventListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> events = []; // Store uploaded events
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _listenToEvents();
  }

  void _listenToEvents() {
    _firestore.collection('events').snapshots().listen((snapshot) {
      setState(() {
        events = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
          : events.isEmpty
          ? const Center(child: Text("No events added yet."))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.deepPurple),
              title: Text(event['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_today, size: 16,
                        color: Colors.deepPurple),
                    const SizedBox(width: 5),
                    Text(event['date'] ?? 'No Date')
                  ]),
                  Row(children: [
                    const Icon(Icons.access_time, size: 16,
                        color: Colors.deepPurple),
                    const SizedBox(width: 5),
                    Text(event['time'] ?? 'No Time')
                  ]),
                  Row(
                    children: [
                      const Icon(Icons.description, size: 16, color: Colors.deepPurple),
                      const SizedBox(width: 5),
                      Expanded( // Prevents overflow
                        child: Text(
                          event['description'] ?? 'No Description',
                          overflow: TextOverflow.ellipsis, // Shorten if too long
                          maxLines: 5, // Limit lines
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_sharp, size: 16, color: Colors.deepPurple),
                      const SizedBox(width: 5),
                      Expanded( // Prevents overflow
                        child: Text(
                          event['location'] ?? 'No Location',
                          overflow: TextOverflow.ellipsis, // Shorten if too long
                          maxLines: 5, // Limit lines
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}