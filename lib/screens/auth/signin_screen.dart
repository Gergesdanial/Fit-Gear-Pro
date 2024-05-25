import 'package:flutter/material.dart';
import 'package:fitness_ecommerce/services/auth_service.dart';
import 'package:fitness_ecommerce/models/user.dart';
import 'package:fitness_ecommerce/screens/profile/home.dart'; // Import the HomeScreen
import 'package:fitness_ecommerce/screens/profile/vendor_home.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'lib/assets/background_image.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.blue), // Blue color for Sign In text
                      ),
                      onPressed: () async {
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        // Admin hardcoded check
                        // Admin hardcoded check
                        if (email == 'admin@app.com' && password == '123456') {
                          Navigator.pushReplacementNamed(context, '/vendorHome');
                          return;
                          }


                        AppUser? user = await _auth.signInWithEmailPassword(email, password);
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomeScreen
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign In Failed')),
                          );
                        }
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.blue), // Blue color for Register text
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
