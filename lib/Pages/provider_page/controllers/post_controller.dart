import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Models/post.dart';
import 'base_controller.dart';
import 'user_controller.dart';

class PostController extends BaseController {
  final RxList<dynamic> posts = <dynamic>[].obs;
  final RxList<dynamic> filteredPosts = <dynamic>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  Future<void> loadPosts() async {
    return handleError(() async {
      final String response = await rootBundle.loadString('assets/data/provider/post.json');
      final data = json.decode(response);
      final userController = UserController.to;

      if (userController.isAdmin) {
        posts.value = data['posts'];
      } else {
        posts.value = data['posts'].where((post) =>
          post['providerId'] == userController.user?.id
        ).toList();
      }
      
      filteredPosts.value = posts;
    });
  }

  void filterPosts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPosts.value = posts;
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    filteredPosts.value = posts.where((post) {
      final title = post['title'].toString().toLowerCase();
      final address = post['address'].toString().toLowerCase();
      final forGender = post['for'].toString().toLowerCase();
      final utilities = (post['utilities'] as List)
          .map((u) => u['name'].toString().toLowerCase())
          .join(' ');

      return title.contains(lowercaseQuery) ||
          address.contains(lowercaseQuery) ||
          forGender.contains(lowercaseQuery) ||
          utilities.contains(lowercaseQuery);
    }).toList();
  }
} 