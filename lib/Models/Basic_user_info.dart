class BasicUserInfo {
  final String? username;
  final String? phone;
  final String? address;
  final String? email;
  final String? fullName;

  BasicUserInfo({
    this.username,
    this.phone,
    this.address,
    this.email,
    this.fullName,
  });
  factory BasicUserInfo.fromMap(Map<String, dynamic> map) {
    return BasicUserInfo(
      username: map['username'],
      phone: map['phone'],
      address: map['address'],
      email: map['email'],
      fullName: map['fullName'],
    );
  }
}