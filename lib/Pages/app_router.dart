import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roomspot/Pages/common_page/Login_page/components/login_page.dart';
import 'package:roomspot/Pages/customer_page/Search_screen/search_screen.dart';
import 'package:roomspot/Pages/customer_page/customer_navbar_page.dart';

class AppRouter {
  static final _router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: LoginPage.path,
        builder: (context, state) => LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, Widget child) => CustomerHomePage(child: child),
        routes: [
          // Route cho trang tìm kiếm
          GoRoute(
            path: SearchScreen.path,
            builder: (context, state) => const SearchScreen(),
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const SearchScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
  static GoRouter get router => _router;
  static SlideTransition _getSlideUpTransition(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
