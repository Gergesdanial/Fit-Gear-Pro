import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_ecommerce/models/product.dart';
import 'package:fitness_ecommerce/screens/products/product_details_screen.dart';
import 'package:fitness_ecommerce/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final Function(Product) onAddToCart;
  final String category;

  const ProductListScreen({required this.onAddToCart, required this.category});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          '${widget.category[0].toUpperCase()}${widget.category.substring(1)} Products',
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
      ),
      child: SafeArea(
        child: StreamBuilder(
          stream: widget.category == 'all'
              ? _productsCollection.snapshots()
              : _productsCollection.where('category', isEqualTo: widget.category).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CupertinoActivityIndicator());
            }

            return GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Product product = Product.fromFirestore(snapshot.data!.docs[index]);
                return GestureDetector(
                  onTap: () async {
                    bool addToCart = await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ProductDetailsScreen(product: product),
                      ),
                    );

                    if (addToCart) {
                      widget.onAddToCart(product);
                    }
                  },
                  child: ProductCard(product: product),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
