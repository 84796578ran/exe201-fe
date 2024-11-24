

import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:roomspot/Pages/customer_page/home_page.dart';
import 'package:roomspot/Pages/customer_page/screen/service_screen/Service_screen.dart';

class WelcomePage extends StatelessWidget {
  static const path ="/welcomePage";
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
                    onPressed: () => context.go(ServiceScreen.path),
                    child: const Text("Customer")
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
