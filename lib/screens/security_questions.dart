import 'package:flutter/material.dart';

class SecurityQuestionsScreen extends StatefulWidget {
  final String userEmail; // To save answers associated with the user

  const SecurityQuestionsScreen({super.key, required this.userEmail});

  @override
  State<SecurityQuestionsScreen> createState() => _SecurityQuestionsScreenState();
}

class _SecurityQuestionsScreenState extends State<SecurityQuestionsScreen> {
  final List<String> _questions = [
    'What is your favorite Bible verse?',
    'What is the name of your first pet?',
    'What is your mother’s maiden name?',
    'What city were you born in?',
    'What is your favorite Christian song?',
  ];

  String? _selectedQuestion1;
  String? _selectedQuestion2;
  final TextEditingController _answer1Controller = TextEditingController();
  final TextEditingController _answer2Controller = TextEditingController();

  void _submitAnswers() {
    if (_selectedQuestion1 == null || _selectedQuestion2 == null ||
        _answer1Controller.text.trim().isEmpty || _answer2Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete both questions and answers")),
      );
      return;
    }

    // You can store the questions and answers in Firebase here if needed.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Security questions saved successfully!")),
    );

    Navigator.pop(context); // Go back after saving
  }

  Widget _buildDropdown(String? selectedQuestion, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedQuestion,
      onChanged: onChanged,
      items: _questions.map((q) {
        return DropdownMenuItem(value: q, child: Text(q));
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Select a question',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Questions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Answer the questions for ${widget.userEmail}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            _buildDropdown(_selectedQuestion1, (val) {
              setState(() {
                _selectedQuestion1 = val;
              });
            }),
            const SizedBox(height: 10),
            TextField(
              controller: _answer1Controller,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            _buildDropdown(_selectedQuestion2, (val) {
              setState(() {
                _selectedQuestion2 = val;
              });
            }),
            const SizedBox(height: 10),
            TextField(
              controller: _answer2Controller,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _submitAnswers,
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}