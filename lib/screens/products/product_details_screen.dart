import 'package:flutter/material.dart';
import 'package:fitness_ecommerce/models/product.dart';
import 'package:fitness_ecommerce/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0.0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    DatabaseService dbService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid ?? '');

    // Calculate the average rating
    double averageRating = widget.product.ratings.isNotEmpty
        ? widget.product.ratings.reduce((a, b) => a + b) / widget.product.ratings.length
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${widget.product.price}',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                SizedBox(height: 16),
                Center(
                  child: Image.network(widget.product.imageUrl),
                ),
                Divider(height: 32, thickness: 2),
                Text(
                  'Average Rating: ${averageRating.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 18),
                ),
                Divider(height: 32, thickness: 2),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Rating (0-5)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          double? rating = double.tryParse(value!);
                          if (rating == null || rating < 0 || rating > 5) {
                            return 'Please enter a valid rating between 0 and 5';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _rating = double.parse(value!);
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Comment',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onSaved: (value) {
                          _comment = value!;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            dbService.updateProductRatingsComments(
                              widget.product.id,
                              _rating,
                              _comment,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(height: 32, thickness: 2),
                Text(
                  'Comments:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                widget.product.comments.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true, // This is needed to make ListView work inside a Column
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.product.comments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.comment),
                            title: Text(widget.product.comments[index]),
                          );
                        },
                      )
                    : Text('No comments yet.'),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Add to Cart'),
                  onPressed: () {
                    Navigator.pop(context, true); // Pass true back to indicate adding to cart
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
