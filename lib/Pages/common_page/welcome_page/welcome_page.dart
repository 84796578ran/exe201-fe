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
        title: const Text("Welcome Page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
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
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const ProviderNavbar()
                         ),
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
