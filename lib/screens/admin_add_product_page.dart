// Full Professional Admin Add Product Page like Amazon/Flipkart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AdminAddProductAdvanced extends StatefulWidget {
  const AdminAddProductAdvanced({super.key});

  @override
  State<AdminAddProductAdvanced> createState() => _AdminAddProductAdvancedState();
}

class _AdminAddProductAdvancedState extends State<AdminAddProductAdvanced> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _brandController = TextEditingController();
  final _tagsController = TextEditingController();
  final _deliveryEstimateController = TextEditingController();

  String _selectedCategory = 'Electronics';
  String _selectedSize = 'M';
  DateTime? _launchDate;
  List<String> _selectedColors = [];
  Uint8List? _imageBytes;

  final List<String> _categories = [
    'Electronics', 'Clothing', 'Home', 'Books', 'Beauty', 'Grocery', 'Toys'
  ];
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _colors = ['Red', 'Blue', 'Green', 'Black', 'White', 'Yellow'];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<Uint8List?> _compressImage(Uint8List bytes) async {
    return await FlutterImageCompress.compressWithList(bytes, quality: 50);
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select product image")));
        return;
      }

      setState(() => _isLoading = true);
      try {
        Uint8List? compressedImage = await _compressImage(_imageBytes!);
        String imageBase64 = base64Encode(compressedImage!);

        double price = double.parse(_priceController.text);
        double discountPrice = double.tryParse(_discountPriceController.text) ?? price;
        double discount = ((price - discountPrice) / price) * 100;

        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text.trim(),
          'description': _descController.text.trim(),
          'price': price,
          'discount_price': discountPrice,
          'discount_percent': discount.toStringAsFixed(1),
          'quantity': int.parse(_qtyController.text.trim()),
          'category': _selectedCategory,
          'size': _selectedSize,
          'brand': _brandController.text.trim(),
          'colors': _selectedColors,
          'tags': _tagsController.text.split(','),
          'delivery_estimate': _deliveryEstimateController.text,
          'launch_date': _launchDate != null ? Timestamp.fromDate(_launchDate!) : null,
          'image_base64': imageBase64,
          'created_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product added successfully")));
        _formKey.currentState!.reset();
        setState(() {
          _imageBytes = null;
          _selectedCategory = 'Electronics';
          _selectedColors = [];
          _launchDate = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildMultiSelectColor() {
    return Wrap(
      spacing: 10,
      children: _colors.map((color) => FilterChip(
        label: Text(color),
        selected: _selectedColors.contains(color),
        onSelected: (bool selected) {
          setState(() {
            selected ? _selectedColors.add(color) : _selectedColors.remove(color);
          });
        },
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product"), backgroundColor: Colors.deepPurple),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: _imageBytes != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_imageBytes!, fit: BoxFit.cover))
                      : const Center(child: Text("Tap to upload image")),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Product Name', Icons.label),
              const SizedBox(height: 12),
              _buildTextField(_descController, 'Description', Icons.description, maxLines: 3),
              const SizedBox(height: 12),
              _buildTextField(_priceController, 'Original Price', Icons.money, isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(_discountPriceController, 'Discounted Price', Icons.local_offer, isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(_qtyController, 'Quantity', Icons.production_quantity_limits, isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(_brandController, 'Brand', Icons.business),
              const SizedBox(height: 12),
              _buildTextField(_tagsController, 'Tags (comma separated)', Icons.tag),
              const SizedBox(height: 12),
              _buildTextField(_deliveryEstimateController, 'Delivery Estimate (e.g. 3-5 days)', Icons.local_shipping),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category), border: OutlineInputBorder()),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedSize,
                decoration: const InputDecoration(labelText: 'Size', prefixIcon: Icon(Icons.straighten), border: OutlineInputBorder()),
                items: _sizes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _selectedSize = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text("Launch Date: ${_launchDate != null ? DateFormat.yMd().format(_launchDate!) : 'Not selected'}"),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => _launchDate = picked);
                      }
                    },
                    child: const Text("Select Date"),
                  )
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitProduct,
                icon: const Icon(Icons.save),
                label: const Text("Add Product"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
    );
  }
}