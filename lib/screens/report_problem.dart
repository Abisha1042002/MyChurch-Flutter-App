import 'package:flutter/material.dart';

class UserReportProblemScreen extends StatefulWidget {
  const UserReportProblemScreen({super.key});

  @override
  State<UserReportProblemScreen> createState() => _UserReportProblemScreenState();
}

class _UserReportProblemScreenState extends State<UserReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedIssueType;

  final List<String> _issueTypes = [
    'Login / Authentication Issue',
    'Profile Update Problem',
    'Notification Not Received',
    'App Performance / Crash',
    'Feature Not Working',
    'Other',
  ];

  final TextEditingController _descriptionController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send data to backend/admin

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you! Your report has been sent.')),
      );

      // Clear form
      setState(() {
        _selectedIssueType = null;
      });
      _descriptionController.clear();
    }
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a User Issue'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedIssueType,
                decoration: InputDecoration(
                  labelText: 'Select Issue Type',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _issueTypes
                    .map((issue) => DropdownMenuItem(
                  value: issue,
                  child: Text(issue),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedIssueType = val;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select an issue type' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Describe the Problem',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
                validator: (value) => _validateNotEmpty(value, 'Description'),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Upload Screenshot (Optional)'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Screenshot upload not implemented yet')),
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade900,
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}