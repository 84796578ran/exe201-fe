import 'package:flutter/material.dart';
import 'package:roomspot/Pages/customer_page/screen/service_screen/Service_screen.dart';
import 'package:roomspot/Pages/provider_page/Provider_navbar_page.dart';

class WelcomePage extends StatelessWidget {
  static const path ="/welcome";
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
            TextSpan(
            children: [
              const TextSpan(text: "Bạn muốn cho thuê phòng\n"),
              const TextSpan(text: "hay thuê phòng"),

            ]
            ),
          textAlign: TextAlign.center,
        )
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
                  child: const Text("Khách hàng"),
                ),
                const SizedBox(width: 20) ,
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const ProviderNavbar()),
                      );
                    },
                    child: const Text("Nhà cung cấp"),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
