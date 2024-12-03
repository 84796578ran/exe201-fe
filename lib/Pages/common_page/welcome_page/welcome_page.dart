import 'package:flutter/material.dart';
import 'package:roomspot/Models/user.dart';
import 'package:roomspot/Pages/customer_page/Home_screen/home_screen.dart';
import 'package:roomspot/Pages/customer_page/customer_navbar_page.dart';
import 'package:roomspot/Pages/provider_page/Provider_navbar_page.dart';
import 'package:roomspot/repositories/user_repository.dart';
import 'package:roomspot/utils/shared_prefs.dart';

class WelcomePage extends StatelessWidget {
  static const path = "/welcome";
  const WelcomePage({super.key});

  Future<void> _updateUserRole(BuildContext context, String role) async {
    try {
      final userEmail = await SharedPrefs.getUserEmail();
      if (userEmail == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Không tìm thấy thông tin người dùng')),
          );
        }
        return;
      }

      final userRepository = UserRepository.instance;
      final user = await userRepository.getUserByEmail(userEmail);

      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Không tìm thấy thông tin người dùng')),
          );
        }
        return;
      }

      // Update user role
      final updatedUser = User(
        id: user.id,
        email: user.email,
        password: user.password,
        fullName: user.fullName,
        avatar: user.avatar,
        phone: user.phone,
        address: user.address,
        role: role,
      );

      await userRepository.updateUser(updatedUser);

      if (context.mounted) {
        // Navigate based on role
        if (role == 'renter') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerHomePage(
                child: HomeScreen(),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProviderNavbar(),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật vai trò: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Bạn muốn đăng kí cho \n"),
                    const TextSpan(text: "thuê phòng hay cho thuê phòng"),
                  ],
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _updateUserRole(context, 'renter'),
                  child: const Text(
                    "Khách hàng",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () => _updateUserRole(context, 'provider'),
                  child: const Text(
                    "Nhà cung cấp",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
