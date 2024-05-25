// product.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  List<double> ratings;
  List<String> comments;
  String category; // Add this line

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.ratings,
    required this.comments,
    required this.category, // Add this line
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      ratings: List<double>.from(data['ratings'] ?? []),
      comments: List<String>.from(data['comments'] ?? []),
      category: data['category'] ?? '', // Add this line
    );
  }
}
