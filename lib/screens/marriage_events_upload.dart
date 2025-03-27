import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class MarriageUploaderPage extends StatefulWidget {
  const MarriageUploaderPage({super.key});

  @override
  MarriageUploaderPageState createState() => MarriageUploaderPageState();
}

class MarriageUploaderPageState extends State<MarriageUploaderPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _bridenameController = TextEditingController();
  final TextEditingController _groomnameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<Map<String, dynamic>> _eventList = [];
  int? _editingEventId;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    QuerySnapshot snapshot = await _firestore.collection('marriage').get();
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
        await _firestore.collection('marriage').add({
          'bridename': _bridenameController.text,
          'groomname': _groomnameController.text,
          'date': formattedDate,
          'time': _selectedTime!.format(context),
          'location': _locationController.text,
        });
      } else {
        await _firestore.collection('marriage').doc(_editingEventId as String?).update({
            'bridename': _bridenameController.text,
            'groomname': _groomnameController.text,
            'date': formattedDate,
            'time': _selectedTime!.format(context),
            'location': _locationController.text,
          },
        );
      }

      _fetchEvents();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_editingEventId == null ? 'Event uploaded successfully!' : 'Event updated successfully!')));

      _formKey.currentState!.reset();
      setState(() {
        _bridenameController.clear();
        _groomnameController.clear();
        _selectedDate = null;
        _selectedTime = null;
        _locationController.clear();
        _editingEventId = null;
      });
    }
  }

  Future<void> _deleteEvent(String id) async {
    await _firestore.collection('marriage').doc(id).delete();
    _fetchEvents();
  }

  void _editEvent(Map<String, dynamic> event) {
    setState(() {
      _editingEventId = event['id'];
      _bridenameController.text = event['bridename'];
      _groomnameController.text = event['groomname'];
      _selectedDate = DateFormat('dd-MM-yyyy').parse(event['date']);

      String time = event['time'];
      int hour = int.parse(time.split(':')[0]);
      int minute = int.parse(time.split(':')[1].split(' ')[0]);

      if (time.contains('PM') && hour != 12) hour += 12;
      if (time.contains('AM') && hour == 12) hour = 0;

      _selectedTime = TimeOfDay(hour: hour, minute: minute);
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
            const Text('Marriage Notice' , style: TextStyle(color: Colors.white), // White text),
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
                    TextFormField(
                      controller: _bridenameController,
                      decoration: const InputDecoration(
                        labelText: 'Bride name',
                        suffixIcon: Icon(Icons.girl_sharp, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                      validator: (value) => value!.isEmpty ? 'Please enter a Bride name' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _groomnameController,
                      decoration: const InputDecoration(
                        labelText: 'Groom name',
                        suffixIcon: Icon(Icons.boy_sharp, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                      validator: (value) => value!.isEmpty ? 'Please enter a Groom name' : null,
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
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        suffixIcon: Icon(Icons.location_on_sharp, color: Colors.deepPurple),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
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
                    leading: const Icon(Icons.event, color: Colors.deepPurple),
                    title: Row(
                      children: [
                        const Icon(Icons.girl_sharp, color: Colors.pink), // Bride Icon
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text('${event['bridename']}',
                            overflow: TextOverflow.ellipsis, // Shorten if too long
                            maxLines: 2, // Limit lines
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.favorite, color: Colors.red), // Heart Icon
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text('${event['groomname']}',
                            overflow: TextOverflow.ellipsis, // Shorten if too long
                            maxLines: 2, // Limit lines
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.boy_sharp, color: Colors.blue), // Groom Icon
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const Icon(Icons.calendar_today, color: Colors.deepPurple), const SizedBox(width: 5), Text(event['date'])]),
                        Row(children: [const Icon(Icons.access_time, color: Colors.deepPurple), const SizedBox(width: 5), Text(event['time'])]),
                        Row(children: [const Icon(Icons.location_on, color: Colors.deepPurple), const SizedBox(width: 5), Expanded(child: Text(event['location']))]),
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
    _bridenameController.dispose();
    _groomnameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}