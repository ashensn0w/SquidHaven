import 'package:flutter/material.dart';
import 'signin.dart';

void main() {
  runApp(const SquidHaven());
}

class SquidHaven extends StatelessWidget {
  const SquidHaven({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SquidHaven',
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}