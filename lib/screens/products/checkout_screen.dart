import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_ecommerce/models/product.dart';
import 'package:fitness_ecommerce/models/order.dart' as CustomOrder;
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> products;
  final Function onOrderPlaced; // Callback to clear the cart

  CheckoutScreen({required this.products, required this.onOrderPlaced});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.products.fold(0, (previousValue, element) => previousValue + element.price);

    // Get the email of the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your address:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(hintText: 'Address'),
            ),
            SizedBox(height: 20),
            Text(
              'Your email: $email',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _placeOrder(email),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // This is the background color
    foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder(String email) async {
    String address = _addressController.text;
    List<String> productNames = widget.products.map((product) => product.title).toList();

    CustomOrder.Order order = CustomOrder.Order(productNames: productNames, address: address, email: email);

    try {
      await FirebaseFirestore.instance.collection('orders').add(order.toMap());
      _showOrderSuccessDialog();
    } catch (e) {
      print('Error placing order: $e');
      _showOrderErrorDialog();
    }
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed'),
          content: Text('Your order has been placed successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onOrderPlaced(); // Clear the cart
                Navigator.of(context).pop(); // Navigate back to the cart screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showOrderErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('There was an error placing your order. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
