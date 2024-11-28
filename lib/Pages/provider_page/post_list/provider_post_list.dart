import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';
import '../controllers/user_controller.dart';
import '../create_post_screen/create_post_page.dart';

class ProviderPostList extends GetView<UserController> {
  final postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phòng'),
        actions: [
          Obx(() => controller.isProvider
            ? IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Get.to(() => CreatePostPage())?.then((_) => postController.loadPosts()),
              )
            : const SizedBox(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: postController.filterPosts,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (postController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (postController.filteredPosts.isEmpty) {
                return const Center(child: Text('Không có phòng nào'));
              }

              return ListView.builder(
                itemCount: postController.filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = postController.filteredPosts[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          post['images'][0],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey,
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      title: Text(post['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['address']),
                          Text('${post['square']}m² - ${post['price']} VNĐ/tháng'),
                          Text('Đối tượng: ${post['for']}'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Chỉnh sửa'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Xóa'),
                          ),
                        ],
                        onSelected: (value) {
                          // Handle edit/delete
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
} 