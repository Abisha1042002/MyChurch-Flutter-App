import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:math';
import 'package:my_church/utils/pdf_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_church/screens/payment_successful_page.dart';
import 'package:my_church/screens/user_report.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> transactions = [];
  String? selectedMethod;
  final otpController = TextEditingController();
  bool showOtpField = false;
  bool showReceipt = false;
  String transactionId = '';
  Map<String, dynamic> latestDonation = {};

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    QuerySnapshot snapshot = await _firestore
        .collection('donations')
        .where('uid', isEqualTo: user.uid) // Filter by current user's UID
        .get();

    setState(() {
      transactions = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
    //QuerySnapshot snapshot = await _firestore.collection('donations').get();
    //setState(() {
      //transactions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    //});
  }

  void _submitDonation() {
    if (_formKey.currentState!.validate() && selectedMethod != null) {
      setState(() {
        showOtpField = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select payment method")),
      );
    }
  }

  void _confirmOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter OTP")),
      );
      return;
    }

    final random = Random();
    transactionId = "TXN${random.nextInt(999999)}";
    String date = DateTime.now().toString();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    Map<String, dynamic> donationData = {
      'uid': user.uid, // Add this line
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'amount': _amountController.text,
      'date': date,
      'transaction_id': transactionId,
      'status': 'Successful',
      'method': selectedMethod,
    };

    await _firestore.collection('donations').add(donationData);
    latestDonation = donationData;
    _loadTransactions();

    setState(() {
      showReceipt = true;
    });
  }

  Future<void> _generateProfessionalReceipt(
      String name,
      String email,
      String phone,
      String amount,
      String date,
      String transactionId,
      ) async {
    final pdf = pw.Document();

    // Load your custom font
    final fontData = await rootBundle.load('assets/Noto_Sans/static/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf,
          italic: ttf,
          boldItalic: ttf,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                pw.Text("Charity Organization", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.Center(child: pw.Text("Donation Receipt", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 20),
        pw.Text("Receipt No: #${DateTime.now().millisecondsSinceEpoch}"),
        pw.Text("Date: $date"),
        pw.SizedBox(height: 10),
        pw.Text("Donor Details:", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.Text("Name: $name"),
        pw.Text("Email: $email"),
        pw.Text("Phone: $phone"),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Transaction id", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(" ₹ Amount", style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(transactionId)),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(amount)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 30),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Authorized Signature"),
            pw.Text("Official Stamp"),
          ],
        ),
        ],
      ),
    ),
    ),
    );
    final pdfData = await pdf.save();
    await downloadPdf(pdfData, "donation_receipt.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B),
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 40, height: 50),
            const SizedBox(width: 10),
            const Text('Donation', style: TextStyle(color: Colors.white)),
          ],
        ),
          actions: [
      IconButton(
      icon: const Icon(Icons.analytics, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportScreen(donations: transactions),), // Change to your Bible page
        );
      },
    ),
    ],
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
                      validator: (value) => value!.trim().isEmpty ? "Enter your name" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Enter your email";
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        return emailRegex.hasMatch(value) ? null : "Enter valid email";
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: "Phone", prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Enter your phone number";
                        if (value.trim().length != 10) return "Phone number must be 10 digits";
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: "Amount", prefixIcon: Icon(Icons.money)),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Enter donation amount";
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) return "Enter valid amount";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedMethod,
                      hint: const Text("Select Payment Method"),
                      items: ['Card', 'UPI', 'Net Banking']
                          .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedMethod = val!),
                      validator: (value) => value == null ? "Select payment method" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitDonation,
                      child: const Text("Proceed to Pay"),
                    ),
                    if (showOtpField && !showReceipt) ...[
                      const SizedBox(height: 20),
                      if (selectedMethod == 'Card') ...[
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Card Number", prefixIcon: Icon(Icons.credit_card)),
                          validator: (value) { if (value == null || value.trim().isEmpty) { return "Enter card number";}
                          if (!RegExp(r'^\d{16}$').hasMatch(value)) { return "Card number must be 16 digits";}
                          return null;},
                        ),
                        TextFormField(decoration: const InputDecoration(labelText: "Card Holder Name", prefixIcon: Icon(Icons.person),),
                          validator: (value) { if (value == null || value.trim().isEmpty) { return "Enter cardholder name";}
                            if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {return "Only alphabets allowed";}
                            return null;},
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Expiry (MM/YY)",
                                  prefixIcon: Icon(Icons.date_range),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Enter expiry date";
                                  }
                                  if (!RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$").hasMatch(value)) {
                                    return "Invalid format (MM/YY)";
                                  }

                                  final now = DateTime.now();
                                  final parts = value.split('/');
                                  final month = int.tryParse(parts[0]);
                                  final year = int.tryParse('20${parts[1]}');

                                  if (month == null || year == null) {
                                    return "Invalid expiry";
                                  }

                                  final expiryDate = DateTime(year, month + 1);
                                  if (expiryDate.isBefore(now)) {
                                    return "Card expired";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "CVV",
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true, // CVV will be hidden
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Enter CVV";
                                  }
                                  if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                                    return "CVV must be 3 digits";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else if (selectedMethod == 'UPI') ...[
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Enter UPI ID", prefixIcon: Icon(Icons.account_balance_wallet)),
                          validator: (value) {if (value == null || value.trim().isEmpty) return "Enter UPI ID";
                          if (!RegExp(r"^[\w.-]+@[\w]+$").hasMatch(value)) return "Invalid UPI ID";
                          return null;
                          }
                        ),
                      ] else if (selectedMethod == 'Net Banking') ...[
                        DropdownButtonFormField<String>(
                          hint: const Text("Select Bank"),
                          items: ['SBI', 'HDFC', 'ICICI', 'Axis', 'Kotak'].map((bank) {
                            return DropdownMenuItem(value: bank, child: Text(bank));
                          }).toList(),
                          onChanged: (value) {},
                          validator: (value) => value == null ? "Select a bank" : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "User ID"),
                          validator: (value) {if (value == null || value.trim().length < 4) return "User ID too short";
                          return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Password"),
                          obscureText: true,
                          validator: (value) {if (value == null || value.trim().length < 6) return "Password must be at least 6 characters";
                          return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: otpController,
                        decoration: const InputDecoration(labelText: "Enter OTP", prefixIcon: Icon(Icons.lock)),
                        validator: (value) {if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) return "Enter 6-digit OTP";
                        if (value != "123456") return "Incorrect OTP"; // Simulated OTP
                        return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          _confirmOtp();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentSuccessPage(),),);},
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Confirm Payment"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                    if (showReceipt)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Card(
                          color: Colors.green.shade50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 6,
                          child: ListTile(
                            title: Text("✅ Payment Successful: ₹${latestDonation['amount']}", style: TextStyle(color: Colors.green.shade900)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Transaction ID: ${latestDonation['transaction_id']}"),
                                Text("Method: ${latestDonation['method']}"),
                                Text("Date: ${latestDonation['date']}"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                              onPressed: () => _generateProfessionalReceipt(
                                latestDonation['name'],
                                latestDonation['email'],
                                latestDonation['phone'],
                                latestDonation['amount'],
                                latestDonation['date'],
                                latestDonation['transaction_id'],
                              ),
                            ),
                          ),
                        ),
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
                        onPressed: () => _generateProfessionalReceipt(
                          transaction['name'],
                          transaction['email'],
                          transaction['phone'],
                          transaction['amount'],
                          transaction['date'],
                          transaction['transaction_id'],
                        ),
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