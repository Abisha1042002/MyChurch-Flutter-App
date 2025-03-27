import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventUploaderPage extends StatefulWidget {
  const EventUploaderPage({super.key});

  @override
  EventUploaderPageState createState() => EventUploaderPageState();
}

class EventUploaderPageState extends State<EventUploaderPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedEvent;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<Map<String, dynamic>> _eventList = [];
  String? _editingEventId;

  final List<Map<String, dynamic>> _churchEvents = [
    {'name': 'Sunday Service', 'icon': Icons.church},
    {'name': 'Prayer Meeting', 'icon': Icons.volunteer_activism},
    {'name': 'Youth Fellowship', 'icon': Icons.people},
    {'name': 'Choir Practice', 'icon': Icons.music_note},
    {'name': 'Holy Communion Services', 'icon': Icons.local_dining},
    {'name': 'Sunday School', 'icon': Icons.menu_book},
    {'name': 'Women Fellowship', 'icon': Icons.female},
    {'name': 'Men Fellowship', 'icon': Icons.male},
    {'name': 'Fasting Prayers', 'icon': Icons.no_food},
    {'name': 'Cottage Prayers', 'icon': Icons.home},
    {'name': 'Harvest Festival', 'icon': Icons.eco},
    {'name': 'Mission Festival', 'icon': Icons.public},
    {'name': 'Vacation Bible School (VBS)', 'icon': Icons.school},
    {'name': 'Elders Fellowship', 'icon': Icons.elderly},
    {'name': 'Young Couples Fellowship', 'icon': Icons.favorite},
    {'name': 'Special Seminars and Retreats', 'icon': Icons.lightbulb},
    {'name': 'Baptism', 'icon': FontAwesomeIcons.dove},
  ];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    QuerySnapshot snapshot = await _firestore.collection('events').get();
    setState(() {
      _eventList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Firestore document ID store pannura
        return data;
      }).toList();
    });
  }

  Future<void> _saveEvent(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);

      if (_editingEventId == null) {
        // Add new event to Firestore
        await _firestore.collection('events').add({
          'name': _selectedEvent,
          'date': formattedDate,
          'time': _selectedTime!.format(context),
          'description': _descriptionController.text,
          'location': _locationController.text,
        });
      } else {
        // Update existing event in Firestore
        await _firestore.collection('events').doc(_editingEventId).update({
          'name': _selectedEvent,
          'date': formattedDate,
          'time': _selectedTime!.format(context),
          'description': _descriptionController.text,
          'location': _locationController.text,
        });
      }

      _fetchEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editingEventId == null ? 'Event uploaded successfully!' : 'Event updated successfully!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedEvent = null;
        _selectedDate = null;
        _selectedTime = null;
        _descriptionController.clear();
        _locationController.clear();
        _editingEventId = null;
      });
    }
  }


  Future<void> _deleteEvent(String id) async {
    await _firestore.collection('events').doc(id).delete();
    _fetchEvents();
  }

  void _editEvent(Map<String, dynamic> event) {
    setState(() {
      _editingEventId = event['id']; // Firestore document ID store pannura
      _selectedEvent = event['name'];
      _selectedDate = DateFormat('dd-MM-yyyy').parse(event['date']);

      String time = event['time'];
      int hour = int.parse(time.split(':')[0]);
      int minute = int.parse(time.split(':')[1].split(' ')[0]);

      if (time.contains('PM') && hour != 12) hour += 12;
      if (time.contains('AM') && hour == 12) hour = 0;

      _selectedTime = TimeOfDay(hour: hour, minute: minute);
      _descriptionController.text = event['description'];
      _locationController.text = event['location'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B), // Golden brown app bar
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 50,
            ),
            const SizedBox(width: 10),
            const Text('Event Uploader' , style: TextStyle(color: Colors.white), // White text),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFFE4B5),
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload Event', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedEvent,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Event Name',
                      ),
                      items: _churchEvents.map((event) {
                        return DropdownMenuItem<String>(
                          value: event['name'],
                          child: Row(
                            children: [
                              Icon(event['icon'], color: Colors.deepPurple),
                              const SizedBox(width: 8),
                              Text(event['name']),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEvent = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select an event' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : ''),
                      decoration: const InputDecoration(
                        labelText: 'Event Date',
                        suffixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      validator: (value) => _selectedDate == null ? 'Please select an event date' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _selectedTime != null ? _selectedTime!.format(context) : ''),
                      decoration: const InputDecoration(
                        labelText: 'Event Time',
                        suffixIcon: Icon(Icons.access_time, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      validator: (value) => _selectedTime == null ? 'Please select an event time' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Event Description',
                        suffixIcon: Icon(Icons.description, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        suffixIcon: Icon(Icons.location_on_sharp, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _saveEvent(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF996515),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_editingEventId == null ? 'Upload Event' : 'Update Event', style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _eventList.length,
              itemBuilder: (context, index) {
                final event = _eventList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(
                      _churchEvents.firstWhere((e) => e['name'] == event['name'], orElse: () => {'icon': Icons.event})['icon'],
                      color: Colors.deepPurple,
                    ),
                    title: Text(event['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const Icon(Icons.calendar_today, color: Colors.deepPurple), const SizedBox(width: 5), Text(event['date'])]),
                        Row(children: [const Icon(Icons.access_time, color: Colors.deepPurple), const SizedBox(width: 5), Text(event['time'])]),
                        Row(children: [const Icon(Icons.description, color: Colors.deepPurple), const SizedBox(width: 5), Expanded(child: Text(event['description']))]),
                        Row(children: [const Icon(Icons.location_on_sharp, color: Colors.deepPurple), const SizedBox(width: 5), Expanded(child: Text(event['location']))]),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editEvent(event),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEvent(event['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}