import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert'; // for base64
import 'package:my_church/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_church/screens/cart_provider.dart';
import 'package:my_church/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = "";
  final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
  List<Map<String, dynamic>> productsList = [];
  List<String> wishlisted = [];

  List<String> adImageAssets = [
    'assets/ad1.png',
    'assets/ad2.png',
    'assets/ad3.png',
    'assets/ad4.png',
  ];

  final List<Map<String, String>> projectTypes = [
    {'name': 'Bible', 'image': 'assets/bibleshop.png'},
    {'name': 'Song books', 'image': 'assets/songbook.png'},
    {'name': 'Accessories', 'image': 'assets/scarf.png'},
    {'name': 'Verse cards', 'image': 'assets/versecards.png'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });

    productsRef.snapshots().listen((QuerySnapshot snapshot) {
      final loaded = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      setState(() => productsList = loaded);
    });
  }

  List<Map<String, dynamic>> get filteredProducts {
    if (_searchQuery.isEmpty) return productsList;
    return productsList.where((product) {
      final name = product['name']?.toLowerCase() ?? '';
      final desc = product['description']?.toLowerCase() ?? '';
      return name.contains(_searchQuery) || desc.contains(_searchQuery);
    }).toList();
  }

  void toggleWishlist(String productId) {
    setState(() {
      if (wishlisted.contains(productId)) {
        wishlisted.remove(productId);
      } else {
        wishlisted.add(productId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyChurch Shop'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for items...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(height: 180, autoPlay: true, enlargeCenterPage: true),
                  items: adImageAssets.map((e) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(e, fit: BoxFit.cover, width: 1000),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: projectTypes.map((proj) {
                      return Column(
                        children: [
                          CircleAvatar(radius: 30, backgroundImage: AssetImage(proj['image']!)),
                          const SizedBox(height: 5),
                          Text(proj['name']!, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recommended for you",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text("No products found"))
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.7),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final isOutOfStock = product['quantity'] == 0;
                      final productId = product['id'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: product, productId: productId)),
                          );
                        },
                        child: Stack(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                      child: product['image_base64'] != null
                                          ? Image.memory(
                                        base64Decode(product['image_base64']),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                          : Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image, size: 60),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(product['name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text("\$${product['price']}",
                                        style: const TextStyle(color: Colors.deepPurple)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(product['rating']?.toStringAsFixed(1) ?? '4.0',
                                            style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: ElevatedButton(
                                      onPressed: isOutOfStock
                                          ? null
                                          : () {
                                        Provider.of<CartProvider>(context, listen: false)
                                            .addToCart(product);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Added to cart"),
                                            duration: Duration(seconds: 1)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text(isOutOfStock ? "Out of Stock" : "Add to Cart"),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => toggleWishlist(productId),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    wishlisted.contains(productId)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}