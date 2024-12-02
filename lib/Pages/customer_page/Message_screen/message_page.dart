import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  static const path = "/message";
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tin nhắn'),
      ),
    );
  }
}
