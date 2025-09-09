import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  double getAverageRating(List<dynamic> ratings) {
    if (ratings.isEmpty) return 0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, i) {
              final product = docs[i].data() as Map<String, dynamic>;
              final docId = docs[i].id;
              Uint8List imageBytes = base64Decode(product['image_base64']);
              int qty = int.tryParse(product['quantity'].toString()) ?? 0;
              bool isOutOfStock = qty == 0;
              double avgRating = getAverageRating(product['ratings'] ?? []);
              List reviews = product['reviews'] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          imageBytes,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(product['category'],
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                            if (product['brand'] != null)
                              Text('Brand: ${product['brand']}',
                                  style: const TextStyle(fontSize: 13)),

                            if (product['size'] != null)
                              Text('Size: ${product['size']}',
                                  style: const TextStyle(fontSize: 13)),

                            if (product['color'] != null)
                              Text('Color: ${product['color']}',
                                  style: const TextStyle(fontSize: 13)),
                            Text('₹${product['price']}',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.green)),
                            if (product['description'] != null)
                              Text(product['description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(avgRating.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            if (reviews.isNotEmpty)
                              Text(
                                'Latest: "${reviews.last}"',
                                style: const TextStyle(
                                    fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                isOutOfStock
                                    ? TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(docId)
                                        .update({'quantity': 1});
                                  },
                                  child: const Text(
                                    'Out of Stock\nTap to Restock',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                    : Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (qty > 0) {
                                          FirebaseFirestore.instance
                                              .collection('products')
                                              .doc(docId)
                                              .update({
                                            'quantity': qty - 1
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red),
                                    ),
                                    Text('Qty: $qty',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(docId)
                                            .update({
                                          'quantity': qty + 1
                                        });
                                      },
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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