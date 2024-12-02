import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roomspot/Pages/common_page/Login_page/components/login_page.dart';
import 'package:roomspot/database/database_helper.dart';

import 'Pages/provider_page/controllers/post_controller.dart';
import 'Pages/provider_page/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseHelper.instance.database;
  Get.put(UserController());
  Get.put(PostController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOMSPOT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/image/splashScreen.jpg'), // Đường dẫn hình nền
            fit: BoxFit.cover, // Tùy chỉnh hình nền full màn hình
          ),
        ),
        child: Column(
          children: [
            const Spacer(), // Đẩy nội dung xuống gần cuối màn hình
            const Center(
              child: Text(
                'ROOMSPOT',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Màu chữ nổi bật trên hình nền
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo góc nút
                  ),
                ),
                child: const Text(
                  'Bắt đầu',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Màu chữ trên nút
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
