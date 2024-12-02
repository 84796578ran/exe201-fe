import 'package:flutter/material.dart';
import '../../../Models/post.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/post_repository.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final PostRepository _postRepository = PostRepository.instance;
  final OrderRepository _orderRepository = OrderRepository.instance;
  Post? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    try {
      final post = await _postRepository.getPost(widget.order.postId);
      setState(() {
        _post = post;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading post: $e')),
        );
      }
    }
  }

  Future<void> _showCancelConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn này không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _cancelOrder();
    }
  }

  Future<void> _cancelOrder() async {
    try {
      await _orderRepository.updateOrderStatus(widget.order.id, 'canceled');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã hủy đơn thành công')),
        );
        Navigator.pop(context, true); // Return true to indicate order was canceled
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error canceling order: $e')),
        );
      }
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Đang chờ duyệt';
      case 'approved':
        return 'Đã duyệt';
      case 'rejected':
        return 'Đã từ chối';
      case 'canceled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'canceled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn đặt phòng'),
        actions: [
          if (widget.order.status.toLowerCase() == 'pending')
            TextButton.icon(
              onPressed: _showCancelConfirmation,
              icon: const Icon(Icons.cancel, size: 20),
              label: const Text('Hủy đơn'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _post == null
              ? const Center(child: Text('Không tìm thấy thông tin phòng'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(widget.order.status),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _getStatusColor(widget.order.status),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getStatusText(widget.order.status),
                              style: TextStyle(
                                color: _getStatusColor(widget.order.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Room Info
                      Card(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: _post!.images.isNotEmpty
                                  ? Image.memory(
                                      _post!.images[0].url,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image),
                                    ),
                            ),
                          ),
                          title: Text(_post!.title),
                          subtitle: Text(_post!.address),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Booking Details
                      const Text(
                        'Chi tiết đặt phòng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Ngày nhận phòng'),
                        subtitle: Text(widget.order.checkIn),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Ngày trả phòng'),
                        subtitle: Text(widget.order.checkOut),
                      ),
                      ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: const Text('Giá thuê'),
                        subtitle: Text('${_post!.price.toStringAsFixed(0)}đ/tháng'),
                      ),
                    ],
                  ),
                ),
    );
  }
} 