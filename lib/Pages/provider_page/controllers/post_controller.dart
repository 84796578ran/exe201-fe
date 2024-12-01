import 'package:get/get.dart';
import '../../../Models/post.dart';
import '../../../repositories/post_repository.dart';
import 'base_controller.dart';
import 'user_controller.dart';

class PostController extends BaseController {
  final PostRepository _postRepository = PostRepository.instance;
  final UserController userController = UserController.to;
  final RxList<Post> posts = <Post>[].obs;
  final RxList<Post> filteredPosts = <Post>[].obs;
  final RxString searchQuery = ''.obs;
  static PostController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  Future<void> loadPosts() async {
    return handleError(() async {
      List<Post> loadedPosts;
      
      if (userController.isAdmin) {
        // Get all posts
        loadedPosts = await _postRepository.getAllPosts();
      } else {
        // Get posts for specific provider
        loadedPosts = await _postRepository.getPostsByProvider(userController.user!.id);
      }
      
      posts.value = loadedPosts;
      filteredPosts.value = loadedPosts;
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
      final title = post.title.toLowerCase();
      final address = post.address.toLowerCase();
      final forGender = post.forGender.toLowerCase();
      final utilities = post.utilities
          .map((u) => u.name.toLowerCase())
          .join(' ');

      return title.contains(lowercaseQuery) ||
          address.contains(lowercaseQuery) ||
          forGender.contains(lowercaseQuery) ||
          utilities.contains(lowercaseQuery);
    }).toList();
  }

  Future<void> createPost(Post newPost) async {
    return handleError(() async {
      // Create post in database
      await _postRepository.createPost(newPost);
      
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

  Future<void> updatePost(Post post) async {
    return handleError(() async {
      await _postRepository.updatePost(post);
      await loadPosts();
      
      Get.snackbar(
        'Success',
        'Post updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> deletePost(String id) async {
    return handleError(() async {
      await _postRepository.deletePost(id);
      await loadPosts();
      
      Get.snackbar(
        'Success',
        'Post deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
} 