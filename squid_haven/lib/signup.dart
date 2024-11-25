import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'signin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle user sign-up
  Future<void> signUp() async {
    final String displayName = displayNameController.text;
    final String email = emailController.text;
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Validate form inputs
    if (displayName.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields.")));
      return;
    }

    try {
      // Send POST request to the server
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/signup'), // API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'displayName': displayName,
          'email': email,
          'username': username,
          'password': password,
        }),
      );

// Check if widget is still mounted before accessing context
      if (!mounted) return;

      if (response.statusCode == 201) {
        // Successful sign-up
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User registered successfully")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } else {
        // Error occurred
        final errorMessage = json.decode(response.body)['error'] ?? 'An error occurred.';
        // Print the error to the console for debugging
        print("SignUp Error: $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // Network error or other issues
      if (!mounted) return;
      // Print the error to the console for debugging
      print("SignUp Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text('SquidHaven'),
        backgroundColor: const Color(0xFFFBFBFB),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView( // Wrap the whole body in a scroll view
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Heading Text
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40), // Space between the heading and input fields

              const Text('Display Name', style: TextStyle(fontSize: 18)),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your display name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const Text('Email', style: TextStyle(fontSize: 18)),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const Text('Username', style: TextStyle(fontSize: 18)),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const Text('Password', style: TextStyle(fontSize: 18)),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),

              // Already have an account? Sign in text button
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(color: Colors.black), // Regular text style
                  children: [
                    TextSpan(
                      text: "Sign in",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the SignInPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}