import 'package:flutter/material.dart';
import 'package:my_church/screens/admin_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  DonationHistoryPageState createState() => DonationHistoryPageState();
}

class DonationHistoryPageState extends State<DonationHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
            const Text(
              'Donation History',
              style: TextStyle(color: Colors.white), // White text
            ),
          ],
        ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.analytics, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminReportPage(),), // Change to your Bible page
                      );
                    },
                  ),
                ],
      ),// Change to your Bible page
      body: StreamBuilder(
        stream: _firestore.collection('donations').orderBy('date', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No donations made yet."));
          }

          var transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Name: ${transaction['name']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${transaction['date']}"),
                      Text("Phone: ${transaction['phone']}"),
                      Text("Transaction ID: ${transaction['transaction_id']}"),
                      Text("Amount: ₹${transaction['amount']}"),
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