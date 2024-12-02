import '../Models/post.dart';
import 'base_repository.dart';

class OrderRepository extends BaseRepository {
  static final OrderRepository instance = OrderRepository._init();
  OrderRepository._init();

  Future<void> createOrder(Order order) async {
    final db = await database;
    await db.insert('orders', order.toDb());
  }

  Future<List<Order>> getOrdersByUser(String userId) async {
    final db = await database;
    final result = await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => Order.fromDb(map)).toList();
  }

  Future<List<Order>> getOrdersByPost(String postId) async {
    final db = await database;
    final result = await db.query(
      'orders',
      where: 'postId = ?',
      whereArgs: [postId],
    );
    return result.map((map) => Order.fromDb(map)).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}