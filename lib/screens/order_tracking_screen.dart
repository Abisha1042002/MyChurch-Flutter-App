import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Order"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'];
          final orderDate = (data['date'] as Timestamp).toDate();
          final estDelivery = orderDate.add(const Duration(days: 4));
          final steps = ['Order Placed', 'Packed', 'Shipped', 'Out for Delivery', 'Delivered'];
          final currentIndex = steps.indexOf(status);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: $orderId", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Estimated Delivery: ${DateFormat('dd MMM yyyy').format(estDelivery)}",
                    style: const TextStyle(color: Colors.teal)),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: index <= currentIndex ? Colors.deepPurple : Colors.grey[300],
                                child: Icon(Icons.check, size: 16, color: Colors.white),
                              ),
                              if (index != steps.length - 1)
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: index < currentIndex ? Colors.deepPurple : Colors.grey[300],
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Text(
                            steps[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: index == currentIndex ? FontWeight.bold : FontWeight.normal,
                              color: index <= currentIndex ? Colors.black : Colors.grey,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}