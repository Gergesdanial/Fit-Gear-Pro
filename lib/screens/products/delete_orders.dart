import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteOrderScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Order'),
      ),
      body: StreamBuilder(
        stream: _db.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return buildOrderList(snapshot);
        },
      ),
    );
  }

  Widget buildOrderList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        QueryDocumentSnapshot order = snapshot.data!.docs[index] as QueryDocumentSnapshot;
        return buildOrderItem(order);
      },
    );
  }

  Widget buildOrderItem(QueryDocumentSnapshot order) {
    Map<String, dynamic> orderData = order.data() as Map<String, dynamic>;
    return Dismissible(
      key: Key(order.id),
      direction: DismissDirection.startToEnd,
      background: buildDismissibleBackground(),
      onDismissed: (direction) {
        _deleteOrder(order.id);
      },
      child: ListTile(
        title: Text('Order ID: ${order.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${orderData['address']}'),
            Text('Email: ${orderData['email']}'),
          ],
        ),
        trailing: Text('Products: ${orderData['productNames'].join(', ')}'),
      ),
    );
  }

  Container buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  void _deleteOrder(String orderId) async {
    try {
      await _db.collection('orders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}

class Order {
  final List<String> productNames;
  final String address;
  final String email;

  Order({required this.productNames, required this.address, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'productNames': productNames,
      'address': address,
      'email': email,
    };
  }
}
