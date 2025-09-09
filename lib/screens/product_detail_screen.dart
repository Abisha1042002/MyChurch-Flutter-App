import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_church/screens/cart_provider.dart';
import 'package:my_church/screens/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;

  const ProductDetailScreen({super.key, required this.product, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    final doc = await FirebaseFirestore.instance.collection('wishlist').doc(widget.productId).get();
    setState(() {
      isFavorite = doc.exists;
    });
  }

  void toggleWishlist() {
    final wishlistRef = FirebaseFirestore.instance.collection('wishlist').doc(widget.productId);
    if (isFavorite) {
      wishlistRef.delete();
    } else {
      wishlistRef.set(widget.product);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    List<dynamic> images = product['images'] ?? [product['image_base64']];
    List<dynamic> ratings = product['ratings'] ?? [];
    List<dynamic> reviews = product['reviews'] ?? [];
    int qty = int.tryParse(product['quantity'].toString()) ?? 0;

    double avgRating = ratings.isEmpty ? 0 : ratings.reduce((a, b) => a + b) / ratings.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleWishlist,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Carousel
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Image.memory(
                    base64Decode(images[index]),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(avgRating.toStringAsFixed(1)),
                      Text(' (${ratings.length} ratings)', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text("₹${product['price']}", style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
                  if (product['offers'] != null)
                    Text("Offer: ${product['offers']}", style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 6),

                  if (qty > 0)
                    const Text("In Stock", style: TextStyle(color: Colors.green))
                  else
                    const Text("Out of Stock", style: TextStyle(color: Colors.red)),

                  const SizedBox(height: 10),

                  // Specs
                  if (product['brand'] != null) Text("Brand: ${product['brand']}"),
                  if (product['size'] != null) Text("Size: ${product['size']}"),
                  if (product['color'] != null) Text("Color: ${product['color']}"),

                  const SizedBox(height: 10),
                  const Divider(),

                  const Text("Product Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(product['description'] ?? '', style: const TextStyle(fontSize: 14)),

                  const Divider(),

                  // Delivery estimate
                  const Text("Delivery in 3-5 days", style: TextStyle(color: Colors.teal)),

                  const SizedBox(height: 20),
                  // Quantity Control
                  Row(
                    children: [
                      const Text("Quantity: "),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text("Add to Cart"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                          onPressed: () {
                            Provider.of<CartProvider>(context,
                                listen: false)
                                .addToCart(product);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                  content:
                                  Text("Added to cart")),
                            );// TODO: Add to cart logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Added to cart")),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text("Buy Now"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: 10),

                  // Reviews
                  if (reviews.isNotEmpty) ...[
                    const Text("Customer Reviews", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    for (var review in reviews.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text("• $review", style: const TextStyle(fontStyle: FontStyle.italic)),
                      ),
                  ],

                  const Divider(),
                  const SizedBox(height: 10),

                  // Frequently Bought Together
                  const Text("Frequently Bought Together", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .where('category', isEqualTo: product['category'])
                        .limit(3)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      final items = snapshot.data!.docs.where((doc) => doc.id != widget.productId).toList();
                      return Column(
                        children: items.map((doc) {
                          final item = doc.data() as Map<String, dynamic>;
                          return ListTile(
                            leading: Image.memory(
                              base64Decode(item['image_base64']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name']),
                            subtitle: Text('₹${item['price']}'),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}