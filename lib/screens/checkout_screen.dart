import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_church/screens/cart_provider.dart';
import 'package:my_church/screens/my_order_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'Cash on Delivery';
  String address = 'No. 12, Church Street, Tirunelveli, TN - 627001';
  final promoController = TextEditingController();
  double discount = 0;

  void applyPromo(String code) {
    if (code.trim().toLowerCase() == 'SAVE10') {
      setState(() {
        discount = 0.10;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Promo Applied: 10% OFF')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Promo Code')));
    }
  }

  void placeOrder(List<Map<String, dynamic>> cartItems, double total) async {
    final orderData = {
      'items': cartItems,
      'total': total - (total * discount),
      'payment_method': selectedPayment,
      'address': address,
      'status': 'Ordered',
      'date': DateTime.now(),
    };

    await FirebaseFirestore.instance.collection('orders').add(orderData);

    Provider.of<CartProvider>(context, listen: false).clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order Placed Successfully!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final total = cartItems.fold<double>(0, (sum, item) {
      final price = double.tryParse(item['price'].toString()) ?? 0;
      return sum + price;
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(address),
            TextButton(
              onPressed: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Edit Address"),
                    content: TextFormField(
                      initialValue: address,
                      onChanged: (value) => address = value,
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, address), child: const Text("Save"))
                    ],
                  ),
                );
                if (result != null) {
                  setState(() {
                    address = result;
                  });
                }
              },
              child: const Text("Edit"),
            ),
            const Divider(),

            const Text("Order Summary", style: TextStyle(fontWeight: FontWeight.bold)),
            ...cartItems.map((item) => ListTile(
              title: Text(item['name']),
              trailing: Text("₹${item['price']}"),
            )),
            const Divider(),

            const Text("Promo Code", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: promoController,
                    decoration: const InputDecoration(hintText: "Enter promo code"),
                  ),
                ),
                TextButton(
                  onPressed: () => applyPromo(promoController.text),
                  child: const Text("Apply"),
                ),
              ],
            ),

            const Divider(),

            const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedPayment,
              items: const [
                DropdownMenuItem(value: 'Cash on Delivery', child: Text("Cash on Delivery")),
                DropdownMenuItem(value: 'Credit/Debit Card', child: Text("Credit/Debit Card")),
                DropdownMenuItem(value: 'UPI', child: Text("UPI")),
                DropdownMenuItem(value: 'Net Banking', child: Text("Net Banking")),
              ],
              onChanged: (value) => setState(() => selectedPayment = value!),
            ),

            const Divider(),

            ListTile(
              title: const Text("Total"),
              trailing: Text(
                "₹${(total - (total * discount)).toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => placeOrder(cartItems, total),
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}