import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const path = "/profile";
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Thông tin cá nhân'),
      ),
    );
  }
}
