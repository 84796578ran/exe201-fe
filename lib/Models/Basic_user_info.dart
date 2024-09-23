class BasicUserInfo {
  BasicUserInfo({
    this.userName,
    this.phone,
    required this.address,
    this.email,
    this.fullName,
    this.gender,
  });

  final String? userName;
  final String? phone;
  final String? address;
  final String? email;
  final String? fullName;
  final String? gender;

  factory BasicUserInfo.fromJson(Map<String, dynamic> json) {
    return BasicUserInfo(
      userName: json['userName'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
      fullName: json['fullName'],
      gender: json['gender'],
    );
  }
}
