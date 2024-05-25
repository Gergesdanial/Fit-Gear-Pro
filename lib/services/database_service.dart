import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

  // Create or update user data
  Future<void> updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  // Get user data
  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  // Get current user ID
 String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // Update product ratings and comments
  Future<void> updateProductRatingsComments(String productId, double rating, String comment) async {
    return await productCollection.doc(productId).update({
      'ratings': FieldValue.arrayUnion([rating]),
      'comments': FieldValue.arrayUnion([comment]),
    });
  }
}