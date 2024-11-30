import 'package:flutter/material.dart';
import 'package:roomspot/Pages/customer_page/screen/service_screen/Service_screen.dart';
import 'package:roomspot/Pages/provider_page/Provider_navbar_page.dart';

class WelcomePage extends StatelessWidget {
  static const path = "/welcome";
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150), // Tăng chiều cao AppBar
        child: AppBar(
          centerTitle: true, // Đặt tiêu đề ở giữa
          backgroundColor: Colors.blue,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40), // Di chuyển nội dung xuống
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Bạn muốn đăng kí cho \n"),
                    const TextSpan(text: "thuê phòng hay thuê phòng"),
                  ],
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24, // Tăng kích thước font chữ
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceScreen(),
                      ),
                    );
                  },
                  child: const Text("Khách hàng", style: TextStyle(fontSize: 20),),

                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ProviderNavbar()),
                    );
                  },
                  child: const Text("Nhà cung cấp", style: TextStyle(fontSize: 20),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
