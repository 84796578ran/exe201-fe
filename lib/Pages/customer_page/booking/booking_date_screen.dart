import 'package:flutter/material.dart';
import 'package:roomspot/Pages/customer_page/booking/booking_confirm_screen.dart';

import '../../../Models/post.dart';

class BookingDateScreen extends StatefulWidget {
  final Post post;

  const BookingDateScreen({super.key, required this.post});

  @override
  State<BookingDateScreen> createState() => _BookingDateScreenState();
}

class _BookingDateScreenState extends State<BookingDateScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  String? errorMessage;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        errorMessage = null; // Reset error message on new selection
        
        if (isCheckIn) {
          checkInDate = picked;
          // If checkout date exists, validate it
          if (checkOutDate != null) {
            final difference = checkOutDate!.difference(picked).inDays;
            if (difference < 30) {
              checkOutDate = null; // Reset invalid checkout date
              errorMessage = 'Thời gian thuê tối thiểu là 1 tháng';
            }
          }
        } else {
          // Validate minimum duration when selecting checkout date
          final difference = picked.difference(checkInDate!).inDays;
          if (difference < 30) {
            errorMessage = 'Thời gian thuê tối thiểu là 1 tháng';
            return;
          }
          checkOutDate = picked;
        }
      });
    }
  }

  bool get isValidDuration {
    if (checkInDate == null || checkOutDate == null) return false;
    final difference = checkOutDate!.difference(checkInDate!).inDays;
    return difference >= 30;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn ngày nhận phòng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sau đây là những ngày nhận phòng khả dụng.',
              style: TextStyle(fontSize: 16),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Ngày nhận phòng'),
              subtitle: Text(
                checkInDate != null ? _formatDate(checkInDate!) : 'Chọn ngày',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: const Text('Ngày trả phòng'),
              subtitle: Text(
                checkOutDate != null ? _formatDate(checkOutDate!) : 'Chọn ngày',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => checkInDate != null
                  ? _selectDate(context, false)
                  : ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng chọn ngày nhận phòng trước'),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            const Text(
              '* Thời gian thuê tối thiểu là 1 tháng',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: isValidDuration
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingConfirmScreen(
                        post: widget.post,
                        checkIn: checkInDate!,
                        checkOut: checkOutDate!,
                      ),
                    ),
                  );
                }
              : null,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Tiếp theo'),
        ),
      ),
    );
  }
}
