import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _filteredDonations = [];
  int _totalAmount = 0;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectDateRange() async {
    await _selectDate(context, true);  // Pick start date
    await _selectDate(context, false); // Pick end date

    if (_startDate != null && _endDate != null) {
      _fetchFilteredDonations(); // Fetch after selecting both dates
    }
  }

  Future<void> _fetchFilteredDonations() async {
    DateTime? start = _startDate;
    DateTime? end = _endDate;

    // If no date selected, show all donations
    if (start == null || end == null) {
      final snapshot = await _firestore
          .collection('donations')
          .orderBy('date', descending: true)
          .get();

      final donations = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? '',
          'phone': data['phone'] ?? '',
          'date': data['date'] is Timestamp
              ? (data['date'] as Timestamp).toDate()
              : DateTime.parse(data['date']),
          'transaction_id': data['transaction_id'] ?? '',
          'amount': data['amount'] ?? 0,
        };
      }).toList();

      final total = donations.fold<int>(0, (sum, item) => sum + int.parse(item['amount'].toString()));

      setState(() {
        _filteredDonations = donations;
        _totalAmount = total;
      });

      return;
    }

    // Include full day for end date (till 23:59:59)
    DateTime endInclusive = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('donations')
        .orderBy('date', descending: true)
        .get();

// Filter manually if some dates are strings
    final donations = snapshot.docs
        .map((doc) {
      final data = doc.data();
      DateTime date;
      if (data['date'] is Timestamp) {
        date = (data['date'] as Timestamp).toDate();
      } else {
        try {
          date = DateTime.parse(data['date']);
        } catch (_) {
          return null; // skip if invalid format
        }
      }

      if (date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          date.isBefore(endInclusive.add(const Duration(seconds: 1)))) {
        return {
          'name': data['name'] ?? '',
          'phone': data['phone'] ?? '',
          'date': date,
          'transaction_id': data['transaction_id'] ?? '',
          'amount': data['amount'] ?? 0,
        };
      } else {
        return null;
      }
    })
        .whereType<Map<String, dynamic>>()
        .toList();

    final total = donations.fold<int>(0, (sum, item) => sum + int.parse(item['amount'].toString()));

    setState(() {
      _filteredDonations = donations;
      _totalAmount = total;
    });
  }

  Future<Uint8List> _generatePdf(List<Map<String, dynamic>> donations, DateTime? startDate, DateTime? endDate) async {
    final pdf = pw.Document();
    final tableHeaders = ['Name', 'Phone', 'Date', 'Txn ID', 'Amount'];

    // Load your custom font
    final fontData = await rootBundle.load('assets/Noto_Sans/static/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final tableRows = donations.map((donation) {
      return [
        donation['name'],
        donation['phone'],
        DateFormat('yyyy-MM-dd').format(donation['date']),
        donation['transaction_id'],
        donation['amount'].toString(),
      ];
    }).toList();

    final dateRangeText = (startDate != null && endDate != null)
        ? "Report from ${DateFormat('yyyy-MM-dd').format(startDate)} to ${DateFormat('yyyy-MM-dd').format(endDate)}"
        : "Full Donation Report";

    final totalAmount = donations.fold<int>(0, (sum, item) => sum + int.parse(item['amount'].toString()));

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf,
          italic: ttf,
          boldItalic: ttf,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('Donation Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(dateRangeText, style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic)),
          pw.SizedBox(height: 10),
          pw.Text('Total Amount Collected: ₹$totalAmount',
              style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: tableRows,
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(5),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> _downloadPdf() async {
    final pdfBytes = await _generatePdf(_filteredDonations, _startDate, _endDate);

    if (kIsWeb) {
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'donation_report.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFilteredDonations();
  }

  @override
  Widget build(BuildContext context) {
    final rangeText = (_startDate != null && _endDate != null)
        ? "Report from ${DateFormat('yyyy-MM-dd').format(_startDate!)} to ${DateFormat('yyyy-MM-dd').format(_endDate!)}"
        : "Full Donation Report";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B),
        title: const Text('Admin Report', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Donation Report', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(rangeText, style: TextStyle(fontSize: 16, color: Colors.grey[700], fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text('Total Amount Collected: ₹$_totalAmount',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child: _filteredDonations.isEmpty
                  ? const Center(child: Text("No donations found in this range."))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Txn ID')),
                    DataColumn(label: Text('Amount')),
                  ],
                  rows: _filteredDonations.map((donation) {
                    return DataRow(cells: [
                      DataCell(Text(donation['name'])),
                      DataCell(Text(donation['phone'])),
                      DataCell(Text(DateFormat('yyyy-MM-dd').format(donation['date']))),
                      DataCell(Text(donation['transaction_id'])),
                      DataCell(Text("₹${donation['amount']}")),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}