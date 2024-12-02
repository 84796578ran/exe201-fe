import 'package:flutter/material.dart';
import '../customer_navbar_page.dart';
import '../Home_screen/home_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Đã nộp đơn xin thuê thành công',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Đơn xin thuê đã được\nchủ sở hữu chấp thuận thành công.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: FilledButton(
                onPressed: () {
                  selectedGlobalIndex.value = 0; // Set index to Home tab
                  // Navigate and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const CustomerHomePage(
                        child: HomeScreen(),
                      ),
                    ),
                    (route) => false, // Remove all previous routes
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Trở lại trang chủ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
