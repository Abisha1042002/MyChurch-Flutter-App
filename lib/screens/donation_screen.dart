import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:async';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  DonationPageState createState() => DonationPageState();
}

class DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  Razorpay? _razorpay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    QuerySnapshot snapshot = await _firestore.collection('donations').get();
    setState(() {
      transactions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String date = DateTime.now().toString();
    Map<String, dynamic> donationData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'amount': _amountController.text,
      'date': date,
      'transaction_id': response.paymentId,  // Store Transaction ID
      'status': 'Successful',
    };
    // Save donation data to Firestore
    await _firestore.collection('donations').add(donationData);
    _loadTransactions();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _startPayment() {
    if (_formKey.currentState!.validate()) {
      var options = {
        'key': 'rzp_test_UNcdjKmpffp4U6',
        'amount': int.parse(_amountController.text) * 100,
        'name': _nameController.text,
        'description': 'Donation Payment',
        'prefill': {'contact': _phoneController.text, 'email': _emailController.text},
      };
      _razorpay!.open(options);
    }
  }

  Future<void> _generateProfessionalReceipt(
      String name, String email, String phone, String amount, String date, String transactionId) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Organization Name
              pw.Text("Charity Organization", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),

              // Receipt Header
              pw.Center(
                child: pw.Text("Donation Receipt", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),

              // Donor Details
              pw.Text("Receipt No: #${DateTime.now().millisecondsSinceEpoch}", style: const pw.TextStyle(fontSize: 12)),
              pw.Text("Date: $date", style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 10),
              pw.Text("Donor Details:", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text("Name: $name"),
              pw.Text("Email: $email"),
              pw.Text("Phone: $phone"),

              pw.SizedBox(height: 15),

              // Donation Details Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Transaction id", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(transactionId),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(amount),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Signature & Stamp
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Authorized Signature", style: const pw.TextStyle(fontSize: 12)),
                  pw.Text("Official Stamp", style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/donation_receipt.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
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
            const Text('Donation' , style: TextStyle(color: Colors.white), // White text),
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
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
                      validator: (value) => value!.isEmpty ? "Enter your name" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                      validator: (value) => value!.isEmpty ? "Enter your email" : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: "Phone", prefixIcon: Icon(Icons.phone)),
                      validator: (value) => value!.isEmpty ? "Enter your phone number" : null,
                    ),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: "Amount", prefixIcon: Icon(Icons.money)),
                      validator: (value) => value!.isEmpty ? "Enter donation amount" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startPayment,
                      child: const Text("Donate Now"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text("${transaction['name']} - ₹${transaction['amount']}"),
                      subtitle: Text("${transaction['date']} - ${transaction['status']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        onPressed: () => _generateProfessionalReceipt(transaction['name'], transaction['email'], transaction['phone'], transaction['amount'], transaction['date'], transaction['transaction_id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}