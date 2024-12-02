import 'package:flutter/material.dart';

import '../../../Models/post.dart';
import '../../../Models/user.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/user_repository.dart';

class ProviderOrderDetailScreen extends StatefulWidget {
  final Order order;
  final Post post;

  const ProviderOrderDetailScreen({
    super.key,
    required this.order,
    required this.post,
  });

  @override
  State<ProviderOrderDetailScreen> createState() =>
      _ProviderOrderDetailScreenState();
}

class _ProviderOrderDetailScreenState extends State<ProviderOrderDetailScreen> {
  final OrderRepository _orderRepository = OrderRepository.instance;
  final UserRepository _userRepository = UserRepository.instance;
  bool _isLoading = true;
  User? _renter;

  @override
  void initState() {
    super.initState();
    _loadRenterInfo();
  }

  Future<void> _loadRenterInfo() async {
    try {
      final renter = await _userRepository.getUser(widget.order.userId);
      setState(() {
        _renter = renter;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading renter info: ${e.toString()}')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showStatusUpdateConfirmation(String newStatus) async {
    final String actionText = newStatus == 'accepted' ? 'chấp nhận' : 'từ chối';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận $actionText đơn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn $actionText đơn này không?'),
            const SizedBox(height: 16),
            Text('Thông tin đơn:'),
            Text('- Người thuê: ${_renter?.fullName ?? "N/A"}'),
            Text('- Phòng: ${widget.post.title}'),
            Text('- Ngày nhận: ${widget.order.checkIn}'),
            Text('- Ngày trả: ${widget.order.checkOut}'),
            const SizedBox(height: 8),
            const Text('Lưu ý: Hành động này không thể hoàn tác.',
                style: TextStyle(color: Colors.red)),
          ],
        ),
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
      await _updateOrderStatus(newStatus);
    }
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      await _orderRepository.updateOrderStatus(widget.order.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật trạng thái thành công')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn đặt phòng'),
        actions: [
          if (widget.order.status.toLowerCase() == 'pending')
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _showStatusUpdateConfirmation('accepted'),
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text('Chấp nhận'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showStatusUpdateConfirmation('canceled'),
                  icon: const Icon(Icons.cancel_outlined, size: 20),
                  label: const Text('Từ chối'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                  const SizedBox(height: 24),
                  // Renter Info
                  const Text(
                    'Thông tin người thuê',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(_renter?.avatar != null
                            ? Icons.person
                            : Icons.person_outline),
                      ),
                      title: Text(_renter?.fullName ?? 'N/A'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_renter?.email ?? 'N/A'),
                          Text(_renter?.phone ?? 'N/A'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Room Info
                  const Text(
                    'Thông tin phòng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        if (widget.post.images.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.memory(
                              widget.post.images[0].url,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(widget.post.address),
                              const SizedBox(height: 8),
                              Text(
                                'Giá: ${widget.post.price.toStringAsFixed(0)}đ/tháng',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
