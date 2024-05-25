import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ecommerce/services/database_service.dart';
import 'package:fitness_ecommerce/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Add this import

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String sendGridApiKey = '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'; // Replace with your SendGrid API key

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(id: user.uid, name: user.displayName ?? '', email: user.email ?? '') : null;
  }

  Stream<AppUser?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<AppUser?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  Future<AppUser?> registerWithEmailPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).updateUserData(name, email);
      await sendWelcomeEmail(name, email); // Send welcome email
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      return null;
    }
  }

  Future<void> sendWelcomeEmail(String name, String email) async {
  final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $sendGridApiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'from': {'email': 'gergesdanial11@outlook.com'}, // Replace with your verified sender email
      'template_id': 'd-a2e50886d4dd49b38e5869a6f03e4a01', // Replace with your SendGrid Template ID
      'personalizations': [
        {
          'to': [
            {'email': email}
          ],
          'dynamic_template_data': {
            'name': name,
          },
        }
      ],
    }),
  );

  if (response.statusCode != 202) {
    print('Error sending email: ${response.body}');
  } else {
    print('Welcome email sent successfully!');
  }
}
}
