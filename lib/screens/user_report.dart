import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportScreen extends StatefulWidget {
  final List<Map<String, dynamic>> donations;

  const ReportScreen({super.key, required this.donations});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String reportType = "monthly";
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  List<Map<String, dynamic>> getChartData() {
    Map<String, int> grouped = {};

    for (var item in widget.donations) {
      try {
        final date = DateTime.parse(item['date']);
        String key = reportType == 'monthly'
            ? DateFormat('dd MMM yyyy').format(date)
            : DateFormat('MMM yyyy').format(date);

        grouped[key] = (grouped[key] ?? 0) + int.parse(item['amount']);
      } catch (e) {
        print("Error: $e");
      }
    }

    var sortedKeys = grouped.keys.toList()
      ..sort((a, b) => DateFormat(
          reportType == 'monthly' ? 'dd MMM yyyy' : 'MMM yyyy')
          .parse(a)
          .compareTo(DateFormat(reportType == 'monthly' ? 'dd MMM yyyy' : 'MMM yyyy')
          .parse(b)));

    return sortedKeys
        .map((key) => {
      'label': reportType == 'monthly'
          ? DateFormat('d').format(DateFormat('dd MMM yyyy').parse(key))
          : DateFormat('MMM').format(DateFormat('MMM yyyy').parse(key)),
      'amount': grouped[key]!,
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = getChartData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Report"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report Type",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueAccent),
            ),
            DropdownButton<String>(
              value: reportType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                    value: "monthly", child: Text("Monthly (Daily View)")),
                DropdownMenuItem(
                    value: "yearly", child: Text("Yearly (Monthly View)")),
              ],
              onChanged: (value) {
                setState(() {
                  reportType = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            if (chartData.isEmpty)
              const Center(child: Text("No donation data available"))
            else
              Expanded(
                child: SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    labelFormat: '₹{value}',
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: chartData,
                      xValueMapper: (data, _) => data['label'],
                      yValueMapper: (data, _) => data['amount'],
                      name: 'Donations',
                      color: Colors.blueAccent,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Total Donation: ₹${widget.donations.fold(0, (sum, item) => sum + int.parse(item['amount']))}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}