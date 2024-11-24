class Room {
  final String? title;
  final String? description;
  final double price;
  final String? address;
  final DateTime? createDate;

  Room({
    this.title,
    this.description,
    required this.price,
    this.address,
    this.createDate,
  });

  // Phương thức tạo đối tượng Room từ Map
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      title: map['title'],
      description: map['description'],
      price: map['price']?.toDouble() ?? 0.0, // Đảm bảo price luôn là double
      address: map['address'],
      createDate: map['createDate'] != null ? DateTime.parse(map['createDate']) : null,
    );
  }
}