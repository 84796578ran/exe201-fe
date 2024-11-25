class RoomBookedService {
  final String id;
  final double finalPrice;
  final String? customerReview;
  final String bookerName;
  final String? bookerPhone;
  final String? room;
  final String? address;
  final String? status;
  final String? createDate;
  final bool isCanceled;

  RoomBookedService({
    required this.id,
    required this.finalPrice,
    this.customerReview,
    required this.bookerName,
    this.bookerPhone,
    this.room,
    this.address,
    this.status,
    this.createDate,
    required this.isCanceled,
  });

  factory RoomBookedService.fromJson(Map<String, dynamic> json) {
    return RoomBookedService(
      id: json['id'],
      finalPrice: json['finalPrice']?.toDouble(),
      customerReview: json['customerReview'],
      bookerName: json['bookerName'],
      bookerPhone: json['bookerPhone'],
      room: json['Room'],
      address: json['Address'],
      status: json['status'],
      createDate: json['createDate'],
      isCanceled: json['isCanceled'] ?? false, // Đảm bảo `isCanceled` có giá trị mặc định nếu không có trong JSON
    );
  }
}
