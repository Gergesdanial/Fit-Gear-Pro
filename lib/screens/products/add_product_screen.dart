import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

  String _selectedCategory = 'shoes'; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Category'),
              items: ['shoes', 'clothing', 'equipment'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String title = _titleController.text;
                String description = _descriptionController.text;
                double price = double.parse(_priceController.text);
                String imageUrl = _imageUrlController.text;

                await _productsCollection.add({
                  'title': title,
                  'description': description,
                  'price': price,
                  'imageUrl': imageUrl,
                  'category': _selectedCategory, // Save category to Firestore
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product Added')),
                );

                _titleController.clear();
                _descriptionController.clear();
                _priceController.clear();
                _imageUrlController.clear();
                setState(() {
                  _selectedCategory = 'shoes'; // Reset to default category
                });
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
