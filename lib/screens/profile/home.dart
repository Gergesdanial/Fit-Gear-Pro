import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_ecommerce/screens/products/product_list_screen.dart';
import 'package:fitness_ecommerce/screens/cart/cart_screen.dart';
import 'package:fitness_ecommerce/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ecommerce/screens/auth/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Product) addToCart;
  final List<Product> cartItems;

  const HomeScreen({required this.addToCart, required this.cartItems});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showUserInfoSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          FirebaseAuth.instance.currentUser?.displayName ?? '',
          style: TextStyle(fontFamily: 'Raleway', fontSize: 18),
        ),
        message: Text(
          FirebaseAuth.instance.currentUser?.email ?? '',
          style: TextStyle(fontFamily: 'Raleway', fontSize: 14),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text('Sign Out', style: TextStyle(fontFamily: 'Raleway')),
            isDestructiveAction: true,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => SignInScreen()),
                (route) => false,
              );
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
  activeColor: Colors.black, // This is the color of the selected tab
  items: [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.bag),
      label: 'Shop',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.cart),
      label: 'Cart',
    ),
  ],
),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Home', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold)),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.profile_circled),
                  onPressed: () {
                    _showUserInfoSheet(context);
                  },
                ),
              ),
              child: _buildHomeContent(context),
            );
          case 1:
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Shop', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold)),
              ),
              child: ProductListScreen(onAddToCart: widget.addToCart, category: 'all'),
            );
          case 2:
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Cart', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold)),
              ),
              child: ShoppingCartScreen(cartItems: widget.cartItems),
            );
          default:
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Home', style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold)),
              ),
              child: _buildHomeContent(context),
            );
        }
      },
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildAnimatedContainer(
                context,
                'Shop Shoes',
                'lib/assets/shoes.jpg',
                '/productListShoes',
              ),
              SizedBox(height: 20),
              _buildAnimatedContainer(
                context,
                'Shop Clothing',
                'lib/assets/cloth.jpg',
                '/productListClothing',
              ),
              SizedBox(height: 20),
              _buildAnimatedContainer(
                context,
                'Shop Equipment',
                'lib/assets/equipements.jpg',
                '/productListEquipment',
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(BuildContext context, String text, String imagePath, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway',
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
