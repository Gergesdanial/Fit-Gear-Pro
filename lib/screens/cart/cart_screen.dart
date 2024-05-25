// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:fitness_ecommerce/models/product.dart';
import 'package:fitness_ecommerce/screens/products/checkout_screen.dart';


class ShoppingCartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const ShoppingCartScreen({required this.cartItems});

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0, (previousValue, element) => previousValue + element.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your shopping cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Dismissible(
                  key: Key(index.toString()), // Using index as key
                  onDismissed: (direction) {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} removed from cart'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            setState(() {
                              cartItems.insert(index, product);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price.toString()}'),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black, // This is the background color
    foregroundColor: Colors.white, // This is the color of the text
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          products: cartItems,
          onOrderPlaced: _clearCart, // Pass the callback to clear the cart
        ),
      ),
    );
  },
  child: Text('Checkout'),
),
            ],
          ),
        ),
      ),
    );
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
  }
}