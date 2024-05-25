import 'package:flutter/material.dart';
import 'package:fitness_ecommerce/screens/products/add_product_screen.dart';
import 'package:fitness_ecommerce/screens/products/delete_product.dart';
import 'package:fitness_ecommerce/screens/products/delete_orders.dart';
import 'package:fitness_ecommerce/screens/auth/signin_screen.dart'; // Import SignInScreen for redirection after logout
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for logout functionality

class VendorHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              child: Text('Add Product'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteProductScreen()),
                );
              },
              child: Text('Delete Product'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteOrderScreen()),
                );
              },
              child: Text('Delete Order'),
            ),
          ],
        ),
      ),
    );
  }
}
