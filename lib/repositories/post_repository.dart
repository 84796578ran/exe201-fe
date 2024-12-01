import '../Models/post.dart';
import 'base_repository.dart';

class PostRepository extends BaseRepository {
  static final PostRepository instance = PostRepository._init();
  PostRepository._init();

  Future<Post?> getPost(String id) async {
    final db = await database;
    
    // Get post data
    final maps = await db.query(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    // Get related data
    final utilities = await db.query(
      'utilities',
      where: 'postId = ?',
      whereArgs: [id],
    );

    final ratings = await db.query(
      'ratings',
      where: 'postId = ?',
      whereArgs: [id],
    );

    final orders = await db.query(
      'orders',
      where: 'postId = ?',
      whereArgs: [id],
    );

    final wishlist = await db.query(
      'wishlist',
      where: 'postId = ?',
      whereArgs: [id],
    );

    // Create Post object directly from database records
    return Post.fromDb(
      maps.first,
      utilities: utilities.map((u) => Utility(
        id: u['id'] as String,
        name: u['name'] as String,
      )).toList(),
      ratings: ratings.map((r) => Rating(
        id: r['id'] as String,
        userId: r['userId'] as String,
        rating: r['rating'] as int,
        comment: r['comment'] as String,
      )).toList(),
      orders: orders.map((o) => Order(
        id: o['id'] as String,
        userId: o['userId'] as String,
        status: o['status'] as String,
        checkIn: o['checkIn'] as String,
        checkOut: o['checkOut'] as String,
      )).toList(),
      wishlist: wishlist.map((w) => Wishlist(
        id: w['id'] as String,
        userId: w['userId'] as String,
      )).toList(),
    );
  }

  Future<List<Post>> getPostsByProvider(String providerId) async {
    final db = await database;
    final result = await db.query(
      'posts',
      where: 'providerId = ?',
      whereArgs: [providerId],
    );
    
    // Get related data for each post
    List<Post> posts = [];
    for (var postMap in result) {
      final post = await getPost(postMap['id'] as String);
      if (post != null) {
        posts.add(post);
      }
    }
    
    return posts;
  }

  Future<List<Post>> getAllPosts() async {
    final db = await database;
    final result = await db.query('posts');
    
    List<Post> posts = [];
    for (var postMap in result) {
      final post = await getPost(postMap['id'] as String);
      if (post != null) {
        posts.add(post);
      }
    }
    
    return posts;
  }

  Future<void> createPost(Post post) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Insert post using toDb()
      await txn.insert('posts', post.toDb());

      // Insert utilities
      for (var utility in post.utilities) {
        await txn.insert('utilities', {
          'id': utility.id,
          'name': utility.name,
          'postId': post.id,
        });
      }

      // Insert ratings
      for (var rating in post.ratings) {
        await txn.insert('ratings', {
          'id': rating.id,
          'userId': rating.userId,
          'postId': post.id,
          'rating': rating.rating,
          'comment': rating.comment,
        });
      }

      // Insert orders
      for (var order in post.orders) {
        await txn.insert('orders', {
          'id': order.id,
          'userId': order.userId,
          'postId': post.id,
          'status': order.status,
          'checkIn': order.checkIn,
          'checkOut': order.checkOut,
        });
      }

      // Insert wishlist
      for (var wish in post.wishlist) {
        await txn.insert('wishlist', {
          'id': wish.id,
          'userId': wish.userId,
          'postId': post.id,
        });
      }
    });
  }

  Future<void> updatePost(Post post) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Update post
      await txn.update(
        'posts',
        {
          'title': post.title,
          'content': post.content,
          'address': post.address,
          'status': post.status,
          'square': post.square,
          'price': post.price,
          'forGender': post.forGender,
          'providerId': post.providerId,
        },
        where: 'id = ?',
        whereArgs: [post.id],
      );

      // Delete existing related data
      await txn.delete('utilities', where: 'postId = ?', whereArgs: [post.id]);
      await txn.delete('ratings', where: 'postId = ?', whereArgs: [post.id]);
      await txn.delete('orders', where: 'postId = ?', whereArgs: [post.id]);
      await txn.delete('wishlist', where: 'postId = ?', whereArgs: [post.id]);

      // Insert new related data
      for (var utility in post.utilities) {
        await txn.insert('utilities', {
          'id': utility.id,
          'name': utility.name,
          'postId': post.id,
        });
      }

      for (var rating in post.ratings) {
        await txn.insert('ratings', {
          'id': rating.id,
          'userId': rating.userId,
          'postId': post.id,
          'rating': rating.rating,
          'comment': rating.comment,
        });
      }

      for (var order in post.orders) {
        await txn.insert('orders', {
          'id': order.id,
          'userId': order.userId,
          'postId': post.id,
          'status': order.status,
          'checkIn': order.checkIn,
          'checkOut': order.checkOut,
        });
      }

      for (var wish in post.wishlist) {
        await txn.insert('wishlist', {
          'id': wish.id,
          'userId': wish.userId,
          'postId': post.id,
        });
      }
    });
  }

  Future<void> deletePost(String id) async {
    final db = await database;
    
    await db.transaction((txn) async {
      // Delete related data first due to foreign key constraints
      await txn.delete('utilities', where: 'postId = ?', whereArgs: [id]);
      await txn.delete('ratings', where: 'postId = ?', whereArgs: [id]);
      await txn.delete('orders', where: 'postId = ?', whereArgs: [id]);
      await txn.delete('wishlist', where: 'postId = ?', whereArgs: [id]);
      
      // Delete the post
      await txn.delete('posts', where: 'id = ?', whereArgs: [id]);
    });
  }

  // Add other CRUD operations as needed
} 