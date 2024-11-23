import 'package:flutter/material.dart';
import 'dart:io';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;



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
  bool _isLoading = false;


  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Bật chế độ loading khi bắt đầu đăng nhập
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      var response = await http.get(
        Uri.parse('https://674151fde4647499008d5b55.mockapi.io/Login'),
      );

      if (response.statusCode == 200) {
        var data = response.body;
        bool isLoginSuccessful = data.contains('"email":"$username"') && data.contains('"password":"$password"');
        if (isLoginSuccessful) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thông báo'),
                content: const Text('Đăng nhập thành công'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email hoặc mật khẩu không đúng')),
          );
        }
      } else {
        // Lỗi từ server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Lỗi kết nối
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Tắt chế độ loading sau khi hoàn thành
      });
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
                        fillColor: Colors.grey[300], // Màu xám cho background
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
                            _obscurePassword ? Icons.visibility_off : Icons.visibility, // Icon con mắt
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Toggle ẩn/hiện mật khẩu
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
                          onChanged: (bool? value) {
                            // Xử lý sự kiện thay đổi trạng thái checkbox
                          },
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
                        backgroundColor: Colors.grey[300], // Màu nền xám cho nút Đăng nhập
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
