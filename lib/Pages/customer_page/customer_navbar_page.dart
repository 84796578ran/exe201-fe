import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:roomspot/Pages/customer_page/Fovorite_screen/favorite_screen.dart';
import 'package:roomspot/Pages/customer_page/Home_screen/home_screen.dart';
import 'package:roomspot/Pages/customer_page/Message_screen/message_page.dart';
import 'package:roomspot/Pages/customer_page/Profile_screen/profile_screen.dart';
import 'package:roomspot/Pages/customer_page/screen/service_screen/Service_screen.dart';

final selectedGlobalIndex = ValueNotifier(0);

class CustomerHomePage extends StatefulWidget {
  final Widget child;

  const CustomerHomePage({
    super.key,
    required this.child
  });

  @override
  State<CustomerHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<CustomerHomePage> {
  static const List<Destination> allDestinations = <Destination>[
    //Destination('Tìm kiếm', Icons.search, Icons.search, Colors.blue, Colors.white, ServiceScreen.path),
    Destination('Tin nhắn', Icons.message, Icons.message, Colors.blue, Colors.white, MessageScreen.path),
    Destination('Trang chủ', Icons.home, Icons.home, Colors.blue, Colors.white, HomeScreen.path),
    Destination('Thông báo', Icons.circle_notifications_outlined, Icons.notification_add_outlined, Colors.blue, Colors.white, FavoriteScreen.path),
    Destination('Cá nhân', Icons.boy, Icons.boy, Colors.blue, Colors.white, ProfileScreen.path),
    // Destination('Hồ sơ', Icons.person_outlined, Icons.person, Colors.blue, Colors.white, LoginPage.path),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedGlobalIndex,
        builder: (context, value, child) {
          selectedGlobalIndex.value = value;
          return NavigationBar(

            onDestinationSelected: (int index) {
              selectedGlobalIndex.value = index;
              context.go(allDestinations[index].path);
            },
            surfaceTintColor: Colors.white,
            indicatorColor: Colors.blue,
            selectedIndex: selectedGlobalIndex.value,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: allDestinations.map((e) => GestureDetector(
              child: NavigationDestination(
                icon: Icon(
                  e.icon,
                  color: e.color,
                  size :40,
                ),
                selectedIcon: Icon(
                  e.selectedIcon,
                  color: e.selectedColor,
                ),
                label: e.title,
              ),
            )).toList(),
          );
        },
      ),
      body: widget.child,
    );
  }
}

class Destination {
  const Destination(this.title, this.icon, this.selectedIcon, this.color, this.selectedColor, this.path);

  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final Color color;
  final Color selectedColor;
  final String path;
}