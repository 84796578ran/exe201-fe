import 'package:flutter/material.dart';
import '../../../Models/post.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/post_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../utils/shared_prefs.dart';
import 'provider_order_detail_screen.dart';

class ProviderOrderListScreen extends StatefulWidget {
  const ProviderOrderListScreen({super.key});

  @override
  State<ProviderOrderListScreen> createState() => _ProviderOrderListScreenState();
}

class _ProviderOrderListScreenState extends State<ProviderOrderListScreen> with SingleTickerProviderStateMixin {
  final OrderRepository _orderRepository = OrderRepository.instance;
  final PostRepository _postRepository = PostRepository.instance;
  final UserRepository _userRepository = UserRepository.instance;
  late TabController _tabController;
  
  List<Order> _orders = [];
  bool _isLoading = true;
  Map<String, Post> _postsMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final userEmail = await SharedPrefs.getUserEmail();
      if (userEmail != null) {
        final user = await _userRepository.getUserByEmail(userEmail);
        if (user != null) {
          final posts = await _postRepository.getPostsByProvider(user.id);
          _postsMap = {for (var post in posts) post.id: post};
          
          final allOrders = await _orderRepository.getAllOrders();
          _orders = allOrders.where((order) => _postsMap.containsKey(order.postId)).toList();
          _orders.sort((a, b) => b.checkIn.compareTo(a.checkIn));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Order> _getFilteredOrders(String status) {
    return _orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Đang chờ duyệt';
      case 'accepted':
        return 'Đã chấp nhận';
      case 'canceled':
        return 'Đã từ chối';
      default:
        return 'Không xác định';
    }
  }

  Widget _buildOrderCard(Order order, Post? post) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final updated = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => ProviderOrderDetailScreen(
                order: order,
                post: post!,
              ),
            ),
          );
          
          if (updated == true) {
            _loadOrders();
          }
        },
        child: Column(
          children: [
            if (post?.images.isNotEmpty == true)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.memory(
                  post!.images[0].url,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          post?.title ?? 'Unknown Post',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(order.status),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          _getStatusText(order.status),
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, 
                        size: 16, 
                        color: Colors.grey
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post?.address ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Check-in: ${order.checkIn}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Check-out: ${order.checkOut}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (post != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${post.price.toStringAsFixed(0)}đ/tháng',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final updated = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProviderOrderDetailScreen(
                                  order: order,
                                  post: post,
                                ),
                              ),
                            );
                            if (updated == true) {
                              _loadOrders();
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Chi tiết'),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
      appBar: AppBar(
        title: const Text('Danh sách đơn đặt phòng'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đang chờ duyệt'),
            Tab(text: 'Đã chấp nhận'),
            Tab(text: 'Đã từ chối'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(_getFilteredOrders('pending')),
                _buildOrderList(_getFilteredOrders('accepted')),
                _buildOrderList(_getFilteredOrders('canceled')),
              ],
            ),
    );
  }

  Widget _buildOrderList(List<Order> filteredOrders) {
    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không có đơn đặt phòng nào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          final post = _postsMap[order.postId];
          return _buildOrderCard(order, post);
        },
      ),
    );
  }
} 