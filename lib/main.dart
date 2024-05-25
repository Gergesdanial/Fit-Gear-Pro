// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_ecommerce/screens/auth/signin_screen.dart';
import 'package:fitness_ecommerce/screens/auth/signup_screen.dart';
import 'package:fitness_ecommerce/screens/products/product_list_screen.dart';
import 'package:fitness_ecommerce/screens/products/add_product_screen.dart';
import 'package:fitness_ecommerce/screens/profile/home.dart'; // Updated to correct import path
import 'package:fitness_ecommerce/screens/cart/cart_screen.dart';
import 'package:fitness_ecommerce/screens/profile/vendor_home.dart'; // Import VendorHomeScreen
import 'package:fitness_ecommerce/models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Product> cartItems = [];

  void addToCart(Product product) {
    setState(() {
      cartItems.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(addToCart: addToCart, cartItems: cartItems),
        '/productList': (context) => ProductListScreen(onAddToCart: addToCart, category: 'all'), // Default category
        '/productListShoes': (context) => ProductListScreen(onAddToCart: addToCart, category: 'shoes'),
        '/productListClothing': (context) => ProductListScreen(onAddToCart: addToCart, category: 'clothing'),
        '/productListEquipment': (context) => ProductListScreen(onAddToCart: addToCart, category: 'equipment'),
        '/addProduct': (context) => AddProductScreen(),
        '/cart': (context) => ShoppingCartScreen(cartItems: cartItems),
        '/vendorHome': (context) => VendorHomeScreen(),
      },
    );
  }
}
