import 'package:flutter/material.dart';
import 'package:roomspot/Pages/provider_page/DetailPost/detail_post_file.dart';
import '../../../Models/post.dart';
import '../../../repositories/post_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../utils/shared_prefs.dart';
import '../create_post_screen/create_post_page.dart';

class ProviderPostList extends StatefulWidget {
  const ProviderPostList({super.key});

  @override
  ProviderPostListState createState() => ProviderPostListState();
}

class ProviderPostListState extends State<ProviderPostList> {
  final PostRepository _postRepository = PostRepository.instance;
  final UserRepository _userRepository = UserRepository.instance;
  final TextEditingController _searchController = TextEditingController();
  
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = false;
  String? _currentUserId;

  Future<void> loadPosts() async {
    setState(() => _isLoading = true);
    try {
      final userEmail = await SharedPrefs.getUserEmail();
      if (userEmail != null) {
        final user = await _userRepository.getUserByEmail(userEmail);
        if (user != null) {
          _currentUserId = user.id;
          final posts = await _postRepository.getPostsByProvider(user.id);
          
          // Sort posts by rating in descending order
          posts.sort((a, b) => b.rating.compareTo(a.rating));
          
          setState(() {
            _posts = posts;
            _filteredPosts = posts;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  // Add method to navigate to create post
  Future<void> _navigateToCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostPage()),
    );
    
    // Refresh the list if post was created successfully
    if (result == true) {
      loadPosts();
    }
  }

  void _filterPosts(String query) {
    if (query.isEmpty) {
      setState(() => _filteredPosts = _posts);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredPosts = _posts.where((post) {
        return post.title.toLowerCase().contains(lowercaseQuery) ||
            post.address.toLowerCase().contains(lowercaseQuery) ||
            post.content.toLowerCase().contains(lowercaseQuery);
      }).toList();
    });
  }

  String _formatPrice(double price) {
    final priceInThousands = price;
    
    final formatted = priceInThousands.toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    
    return '${formatted}đ/tháng';
  }

  Widget _buildPostCard(Post post, int index) {
    String genderText = '';
    Color genderColor = Colors.blue;

    switch (post.forGender.toLowerCase()) {
      case 'male':
        genderText = 'Nam';
        genderColor = Colors.blue;
        break;
      case 'female':
        genderText = 'Nữ';
        genderColor = Colors.pink;
        break;
      default:
        genderText = 'Tất cả';
        genderColor = Colors.green;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreenProvider(post: post),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Main content
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image section with fixed width
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          post.images.isNotEmpty
                              ? Image.memory(
                            post.images[0].url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                          // Gender badge
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: genderColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                genderText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Content section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  post.address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.square_foot, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${post.square}m²',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              if (post.utilities.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.check_circle_outline, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    post.utilities.first.name,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < post.rating.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  );
                                }),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.rating}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatPrice(post.price),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Top badge if index < 3
            if (index < 3)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Top ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _filterPosts,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPosts.isEmpty
                    ? const Center(child: Text('Không có phòng nào'))
                    : RefreshIndicator(
                        onRefresh: loadPosts,
                        child: ListView.builder(
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) =>
                              _buildPostCard(_filteredPosts[index], index),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
