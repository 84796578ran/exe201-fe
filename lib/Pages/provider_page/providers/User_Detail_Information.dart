import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  final String userId; // Truyền ID của người dùng để hiển thị

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // JSON data - có thể thay bằng API hoặc file JSON
    final String jsonData = '''
{
  "users": [
    {
      "email": "quynhthuvuhai@gmail.com",
      "password": "1",
      "phone": "0946291203",
      "address": "Linh Đông, Thủ Đức",
      "role": "renter",
      "fullName": "Thu Thủy",
      "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/481.jpg",
      "id": "1"
    }
    // Thêm dữ liệu user tại đây
  ]
}
''';

    final Map<String, dynamic> data = json.decode(jsonData);
    final users = data['users'] as List<dynamic>;

    // Tìm người dùng theo ID
    final user = users.firstWhere(
            (user) => user['id'].toString() == widget.userId,
        orElse: () => null);

    if (user != null) {
      setState(() {
        userData = user as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userData?['fullName'] ?? 'Loading...'),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData!['avatar']),
                radius: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${userData!['fullName'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${userData!['email']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${userData!['phone'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: ${userData!['address'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${userData!['role']}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}