import 'dart:convert';
import 'dart:typed_data';

class User {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final Uint8List? avatar;
  final String phone;
  final String address;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    this.avatar,
    this.phone = '',
    this.address = '',
    this.role = 'user',
  });

  // Create from database record
  factory User.fromDb(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      fullName: map['fullName'] as String,
      avatar: map['avatar'] as Uint8List?,
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      role: map['role'] as String? ?? 'user',
    );
  }

  // Convert to database record
  Map<String, dynamic> toDb() => {
    'id': id,
    'email': email,
    'password': password,
    'fullName': fullName,
    'avatar': avatar,
    'phone': phone,
    'address': address,
    'role': role,
  };

  // For initial data loading from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    String? avatarStr = json['avatar'];
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: avatarStr != null && avatarStr.isNotEmpty 
          ? base64Decode(avatarStr)
          : null,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  // For API communications
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'fullName': fullName,
    'avatar': avatar != null ? base64Encode(avatar!) : '',
    'phone': phone,
    'address': address,
    'role': role,
  };
}
