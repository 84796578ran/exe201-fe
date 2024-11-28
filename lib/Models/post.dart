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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'address': address,
        'status': status,
        'square': square,
        'price': price,
        'for': forGender,
        'providerId': providerId,
        'utilities': utilities.map((u) => u.toJson()).toList(),
        'ratings': ratings.map((r) => r.toJson()).toList(),
        'images': images,
        'orders': orders.map((o) => o.toJson()).toList(),
        'wishlist': wishlist.map((w) => w.toJson()).toList(),
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