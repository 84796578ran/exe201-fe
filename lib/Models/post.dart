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
  List<String> images;
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

  // Create from database record
  factory Post.fromDb(Map<String, dynamic> map, {
    List<Utility> utilities = const [],
    List<Rating> ratings = const [],
    List<Order> orders = const [],
    List<Wishlist> wishlist = const [],
  }) {
    return Post(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      address: map['address'],
      status: map['status'],
      square: map['square'],
      price: map['price'],
      forGender: map['forGender'],
      providerId: map['providerId'],
      utilities: utilities,
      ratings: ratings,
      orders: orders,
      wishlist: wishlist,
      images: const [], // Handle images separately
    );
  }

  // Convert to database record
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
  String status;
  String checkIn;
  String checkOut;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.checkIn,
    required this.checkOut,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'status': status,
        'checkIn': checkIn,
        'checkOut': checkOut,
      };
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