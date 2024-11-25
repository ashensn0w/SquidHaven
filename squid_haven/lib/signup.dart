import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'signin.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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

              const Text(
                'Display Name',
                style: TextStyle(fontSize: 18),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your display name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20), // Space between fields

              const Text(
                'Email',
                style: TextStyle(fontSize: 18),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20), // Space between fields

              // Username Text and Field
              const Text(
                'Username',
                style: TextStyle(fontSize: 18),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20), // Space between fields

              // Password Text and Field
              const Text(
                'Password',
                style: TextStyle(fontSize: 18),
              ),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40), // Space between password field and sign-in button

              // Sign In Floating Button
              FloatingActionButton(
                onPressed: () {
                  // Navigate to the SignUpPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.login),
              ),
              const SizedBox(height: 20), // Space between the button and sign-up text

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