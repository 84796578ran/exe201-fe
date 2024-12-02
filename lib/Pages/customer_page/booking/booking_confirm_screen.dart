import 'package:flutter/material.dart';
import 'package:roomspot/Pages/customer_page/booking/booking_success_screen.dart';

import '../../../Models/post.dart';
import '../../../repositories/order_repository.dart';
import '../../../utils/shared_prefs.dart';

class BookingConfirmScreen extends StatelessWidget {
  final Post post;
  final DateTime checkIn;
  final DateTime checkOut;

  const BookingConfirmScreen({
    super.key,
    required this.post,
    required this.checkIn,
    required this.checkOut,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return '$formatted/tháng';
  }

  Future<void> _submitBooking(BuildContext context) async {
    try {
      final userEmail = await SharedPrefs.getUserEmail();
      if (userEmail == null) {
        throw Exception('User not logged in');
      }

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userEmail,
        postId: post.id,
        status: 'pending',
        checkIn: _formatDate(checkIn),
        checkOut: _formatDate(checkOut),
      );

      await OrderRepository.instance.createOrder(order);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingSuccessScreen(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đặt phòng'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room info card
            Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: post.images.isNotEmpty
                        ? Image.memory(
                            post.images[0].url,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                  ),
                ),
                title: Text(post.title),
                subtitle: Text(post.address),
              ),
            ),
            const SizedBox(height: 24),
            // Booking details
            const Text(
              'Chi tiết đặt phòng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Ngày nhận phòng: ${_formatDate(checkIn)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Ngày trả phòng: ${_formatDate(checkOut)}'),
              ],
            ),
            const SizedBox(height: 24),
            // Price details
            const Text(
              'Chi tiết thanh toán',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Giá thuê'),
                Text(_formatPrice(post.price)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => _submitBooking(context),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Tiếp theo'),
        ),
      ),
    );
  }
}
