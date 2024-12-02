import 'dart:typed_data';

class Post {
  String id;
  String title;
  String content;
  String address;
  String status;
  double square;
  double price;
  String forGender;
  String providerId;
  List<Utility> utilities;
  List<Rating> ratings;
  List<PostImage> images;
  List<Order> orders;
  List<Wishlist> wishlist;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.address,
    required this.status,
    required this.square,
    required this.price,
    required this.forGender,
    required this.providerId,
    required this.utilities,
    required this.images,
    this.ratings = const [],
    this.orders = const [],
    this.wishlist = const [],
  });

  double get rating {
    if (ratings.isEmpty) return 0.0;
    final sum = ratings.fold(0, (sum, item) => sum + item.rating);
    return double.parse((sum / ratings.length).toStringAsFixed(1));
  }

  factory Post.fromDb(
    Map<String, dynamic> map, {
    List<Utility> utilities = const [],
    List<Rating> ratings = const [],
    List<Order> orders = const [],
    List<Wishlist> wishlist = const [],
    List<PostImage> images = const [],
  }) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      address: map['address'] as String,
      status: map['status'] as String,
      square: map['square'] as double,
      price: map['price'] as double,
      forGender: map['forGender'] as String,
      providerId: map['providerId'] as String,
      utilities: utilities,
      ratings: ratings,
      orders: orders,
      wishlist: wishlist,
      images: images,
    );
  }

  Map<String, dynamic> toDb() => {
        'id': id,
        'title': title,
        'content': content,
        'address': address,
        'status': status,
        'square': square,
        'price': price,
        'forGender': forGender,
        'providerId': providerId,
      };
}

class Utility {
  String id;
  String name;

  Utility({required this.id, required this.name});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Rating {
  String id;
  String userId;
  int rating;
  String comment;

  Rating({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'rating': rating,
        'comment': comment,
      };
}

class Order {
  String id;
  String userId;
  String postId;
  String status;
  String checkIn;
  String checkOut;

  Order({
    required this.id,
    required this.userId,
    required this.postId,
    required this.status,
    required this.checkIn,
    required this.checkOut,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'postId': postId,
        'status': status,
        'checkIn': checkIn,
        'checkOut': checkOut,
      };

  Map<String, dynamic> toDb() => {
        'id': id,
        'userId': userId,
        'postId': postId,
        'status': status,
        'checkIn': checkIn,
        'checkOut': checkOut,
      };

  factory Order.fromDb(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['userId'] as String,
      postId: map['postId'] as String,
      status: map['status'] as String,
      checkIn: map['checkIn'] as String,
      checkOut: map['checkOut'] as String,
    );
  }
}

class Wishlist {
  String id;
  String userId;

  Wishlist({required this.id, required this.userId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
      };
}

class PostImage {
  String id;
  String postId;
  Uint8List url;

  PostImage({
    required this.id,
    required this.postId,
    required this.url,
  });

  factory PostImage.fromDb(Map<String, dynamic> map) {
    return PostImage(
      id: map['id'] as String,
      postId: map['postId'] as String,
      url: map['url'] as Uint8List,
    );
  }

  Map<String, dynamic> toDb() => {
        'id': id,
        'postId': postId,
        'url': url,
      };
}
