

import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:roomspot/Pages/customer_page/customer_navbar_page.dart';
import 'package:roomspot/Pages/customer_page/screen/service_screen/Service_screen.dart';

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
                    // Chuyển hướng đến ServiceScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceScreen(),
                      ),
                    );
                  },
                  child: const Text("Customer"),

                ),
                // ElevatedButton(
                //     onPressed: () => context.go(ServiceScreen.path),
                //     child: const Text("Customer")
                //),
              ],
            )
          ],
        ),
      )
    );
  }
}
