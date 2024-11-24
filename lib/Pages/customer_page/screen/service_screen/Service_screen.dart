import 'package:flutter/material.dart';
import 'package:roomspot/Models/room.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Dùng để parse JSON

class ServiceScreen extends StatefulWidget {
  static const path = '/service';
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late List<Room> roomService = [];
  bool _isLoading = false;

  // Fetch API để lấy danh sách các phòng
  void _fetchServices() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });

    try {
      final response = await http.get(
        Uri.parse('https://674151fde4647499008d5b55.mockapi.io/getAllPost'),
      );

      if (response.statusCode == 200) {
        // Parse JSON từ response body
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          // Chuyển đổi dữ liệu JSON thành danh sách các đối tượng Room
          roomService = data.map((item) => Room.fromMap(item)).toList();
          _isLoading = false; // Kết thúc tải
        });
      } else {
        // Xử lý nếu API trả về lỗi
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Kết thúc tải khi có lỗi
      });
      // Hiển thị lỗi trong debug console
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchServices(); // Gọi hàm fetch API khi khởi tạo màn hình
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ cho thuê phòng'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Hiển thị loading spinner
      )
          : roomService.isEmpty
          ? const Center(
        child: Text('Không có phòng nào được tìm thấy!'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: roomService.length,
        itemBuilder: (context, index) {
          final room = roomService[index];
          return ServiceCard(
            title: room.title ?? 'Không có tiêu đề',
            description: room.description ?? 'Không có mô tả',
            price: room.price.toString(),
            address: room.address ?? 'Không có địa chỉ',
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String address;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Giá: $price VNĐ',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Địa chỉ: $address',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
