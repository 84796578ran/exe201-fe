class User {
  final String id;
  final String username;
  final String fullName;
  final String avatar;
  final String phone;
  final String address;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.avatar,
    this.phone = '',
    this.address = '',
    this.role = 'user',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'avatar': avatar,
    'phone': phone,
    'address': address,
    'role': role,
  };
} 