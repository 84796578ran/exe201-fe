import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:roomspot/Pages/common_page/register_page/register_page.dart';
import 'package:roomspot/Pages/common_page/welcome_page/welcome_page.dart';
import 'package:roomspot/Pages/provider_page/controllers/user_controller.dart';

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

  Future<void> _login() async {
    final email = _usernameController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _userController.showError('Please enter email and password');
      return;
    }

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/common/user.json');
      final jsonData = json.decode(jsonString);
      final users = jsonData['users'] as List;

      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (user != null) {
        _userController.setUser(user);
        _userController.showSuccess('Login successful');

        if (_userController.isProvider) {
          /*_userController.toProviderDashboard();*/
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        } else {
          _userController.toHome();
        }
      } else {
        _userController.showError('Invalid credentials');
      }
    } catch (e) {
      _userController.showError('Login failed: $e');
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
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("Đăng ký với Facebook");
                      },
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
                          Icon(
                            Icons.facebook,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text('Đăng ký với Facebook'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        print("Đăng ký với Google");
                      },
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
              // Container 2: Chứa các thành phần còn lại như Email, Password, và các liên kết
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ô nhập Email
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        hintText: 'Nhập email',
                        fillColor: Colors.grey[300],
                        // Màu xám cho background
                        filled: true, // Bật tính năng điền màu nền
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        hintText: 'Nhập mật khẩu',
                        fillColor: Colors.grey[300],
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility, // Icon con mắt
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword; // Toggle ẩn/hiện mật khẩu
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
                        const Text("Ghi Nhớ mật khẩu"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Nút Đăng nhập
                    ElevatedButton(
                      onPressed: () {
                        _login();
                        print('Username: ${_usernameController.text}');
                        print('Password: ${_passwordController.text}');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor:
                            Colors.grey[300], // Màu nền xám cho nút Đăng nhập
                      ),
                      child: const Text('Đăng nhập'),
                    ),
                    const SizedBox(height: 16),

                    // Phần liên kết "Chưa có tài khoản?" và "Quên mật khẩu?"
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                            RegistrationPage()));
                                print('Đăng ký ngay bây giờ');
                              },
                              child: const Text(
                                'Đăng ký ngay bây giờ',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                print('Quên mật khẩu');
                              },
                              child: const Text(
                                'Quên mật khẩu?',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
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
