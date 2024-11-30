import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roomspot/Pages/common_page/register_page/register_page.dart';
import 'package:roomspot/Pages/common_page/welcome_page/welcome_page.dart';
import 'package:roomspot/Pages/customer_page/Home_screen/home_screen.dart';
import 'package:roomspot/Pages/customer_page/customer_navbar_page.dart';
import 'package:roomspot/Pages/provider_page/Provider_navbar_page.dart';
import 'package:roomspot/Pages/provider_page/controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_EMAIL_KEY = 'user_email';

class LoginPage extends StatefulWidget {
  static const path = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _userController = UserController.to;

  /// Lưu email người dùng vào SharedPreferences
  Future<void> _saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_EMAIL_KEY, email);
    print('User email saved: ${prefs.getString(USER_EMAIL_KEY)}');
  }

  /// Xử lý đăng nhập
  Future<void> _login() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Kiểm tra xem các trường có rỗng không
    if (email.isEmpty || password.isEmpty) {
      _userController.showError('Vui lòng nhập email và mật khẩu');
      return;
    }

    try {
      // Tải dữ liệu từ file JSON
      final jsonString =
      await rootBundle.loadString('assets/data/common/user.json');
      final jsonData = json.decode(jsonString);
      final users = jsonData['users'] as List;

      // Tìm người dùng
      final user = users.firstWhere(
            (u) => u['email'] == email && u['password'] == password,
        orElse: () => null, // Trả về null nếu không tìm thấy
      );

      if (user != null) {
        // Lưu email và cập nhật trạng thái người dùng
        await _saveUserEmail(email);
        _userController.setUser(user);

        // Hiển thị thông báo thành công
        _userController.showSuccess('Đăng nhập thành công');

        // Điều hướng dựa trên vai trò
        if (_userController.isProvider) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProviderNavbar()),
          );
        } else if (_userController.renter) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomerHomePage(child: HomeScreen())),
          );
        }
      } else {
        _userController.showError('Tài khoản hoặc mật khẩu không đúng');
      }
    } catch (e) {
      // Xử lý lỗi (ví dụ: file JSON không hợp lệ)
      _userController.showError('Đăng nhập thất bại: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Container 1: Đăng ký bằng Facebook hoặc Google
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => print("Đăng ký với Facebook"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.facebook, size: 24),
                          const SizedBox(width: 10),
                          const Text('Đăng ký với Facebook'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => print("Đăng ký với Google"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Đăng ký với Google'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 180),

              // Container 2: Nhập Email, Password và nút Đăng nhập
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        hintText: 'Nhập email',
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        hintText: 'Nhập mật khẩu',
                        fillColor: Colors.grey[300],
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        const Text("Ghi nhớ mật khẩu"),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Nút Đăng nhập
                    ElevatedButton(
                      onPressed: () => _login(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Đăng nhập'),
                    ),

                    const SizedBox(height: 16),

                    // Liên kết "Đăng ký" và "Quên mật khẩu"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const RegistrationPage()),
                            );
                          },
                          child: const Text(
                            'Đăng ký ngay bây giờ',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => print('Quên mật khẩu'),
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
