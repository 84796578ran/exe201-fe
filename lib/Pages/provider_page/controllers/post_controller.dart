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
  static PostController get to => Get.find();

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

  Future<void> createPost(Post newPost) async {
    return handleError(() async {
      // Load current posts
      final String response = await rootBundle.loadString('assets/data/provider/post.json');
      final data = json.decode(response);
      final currentPosts = List<Map<String, dynamic>>.from(data['posts']);
      
      // Get the highest ID and increment by 1
      int maxId = 0;
      for (var post in currentPosts) {
        int currentId = int.parse(post['id']);
        if (currentId > maxId) {
          maxId = currentId;
        }
      }
      
      // Set the new post ID
      newPost.id = (maxId + 1).toString();
      
      // Add the new post to the list
      currentPosts.add(newPost.toJson());
      
      // Update the posts list
      data['posts'] = currentPosts;
      
      // Convert back to JSON string
      final String updatedJson = json.encode(data);
      
      // For now, just print the JSON as we can't write to assets in production
      print('Updated JSON:');
      print(updatedJson);
      
      // Reload posts
      await loadPosts();
      
      // Show success message
      Get.snackbar(
        'Success',
        'Post created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
} 