import 'package:flutter/material.dart';
import '../../../Models/user.dart';
import '../../../repositories/user_repository.dart';

class ProviderProfileScreen extends StatefulWidget {
  final String providerId;

  const ProviderProfileScreen({
    super.key,
    required this.providerId,
  });

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final UserRepository _userRepository = UserRepository.instance;
  User? provider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviderInfo();
  }

  Future<void> _loadProviderInfo() async {
    final providerData = await _userRepository.getUser(widget.providerId);
    if (mounted) {
      setState(() {
        provider = providerData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin chủ phòng'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider == null
              ? const Center(child: Text('Không tìm thấy thông tin chủ phòng'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, size: 50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          provider!.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoTile(Icons.phone, 'Số điện thoại', provider!.phone),
                      _buildInfoTile(Icons.email, 'Email', provider!.email),
                      // Add more provider information as needed
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 