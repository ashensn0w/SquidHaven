import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'signup.dart';
import 'home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Validate form inputs
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields.")));
      return;
    }

    try {
      // Send POST request to the server
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (!mounted) return; // Check if widget is still mounted before accessing context
      if (response.statusCode == 200) {
        // Successful sign-in
        final responseBody = json.decode(response.body);
        final username = responseBody['user']?['username'] ?? 'Unknown user';
        final displayName = responseBody['user']?['display_name'] ?? 'No display name';

        print('User signed in: $displayName - $username');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign-in successful")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username: username, displayName: displayName)), // Pass displayName
        );
      } else {
        // Error occurred
        final errorMessage = json.decode(response.body)['error'] ?? 'An error occurred.';
        print('SignIn Error: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // Network error or other issues
      if (!mounted) return;
      print('SignIn Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Set background color to #F1F0E8
      appBar: AppBar(
        title: const Text('SquidHaven'),
        backgroundColor: const Color(0xFFFBFBFB),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Heading Text
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40), // Space between the heading and input fields

              // Username Text and Field
              const Text(
                'Username',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20), // Space between username and password fields

              // Password Text and Field
              const Text(
                'Password',
                style: TextStyle(fontSize: 18),
              ),
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
              const SizedBox(height: 40), // Space between password field and sign-in button

              // Sign In Button
              ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20),

              // Don't have an account? Sign up text button
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black), // Regular text style
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the SignUpPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
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