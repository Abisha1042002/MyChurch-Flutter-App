import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class MarriageListPage extends StatefulWidget {
  const MarriageListPage({super.key});

  @override
  MarriageListPageState createState() => MarriageListPageState();
}

class MarriageListPageState extends State<MarriageListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> marriage = []; // Store uploaded events

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Fetch Events from Database
  Future<void> _fetchEvents() async {
    QuerySnapshot snapshot = await _firestore.collection('marriage').get();
    setState(() {
      marriage = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: FutureBuilder(
        future: _fetchEvents(), // Call fetch every time build runs
        builder: (context, snapshot) {
          if (marriage.isEmpty) {
            return const Center(child: Text("No events added yet."));
          }
          return ListView.builder(
            itemCount: marriage.length,
            itemBuilder: (context, index) {
              final event = marriage[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.deepPurple),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.girl_sharp, color: Colors.pink), // Bride Icon
                        const SizedBox(width: 2),
                        Text('${event['bridename']}',
                            maxLines: 2,), // Limit lines
                          ]),
                        Row(
                          children:[
                        const Icon(Icons.boy_sharp, color: Colors.blue), // Groom Icon
                        const SizedBox(width: 2),
                          Text('${event['groomname']}',
                            maxLines: 2, ),// Limit lines
                          ]),
                  Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16,
                            color: Colors.deepPurple),
                        const SizedBox(width: 5),
                        Text(event['date'])
                      ]),
                      Row(children: [
                        const Icon(Icons.access_time, size: 16,
                            color: Colors.deepPurple),
                        const SizedBox(width: 5),
                        Text(event['time'])
                      ]),
                      Row(
                        children: [
                          const Icon(Icons.location_on_sharp, size: 16, color: Colors.deepPurple),
                          const SizedBox(width: 5),
                          Expanded( // Prevents overflow
                            child: Text(
                              event['location'],
                              overflow: TextOverflow.ellipsis, // Shorten if too long
                              maxLines: 1, // Limit lines
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
              );
            },
          );
        },
      ),
    );
  }
}