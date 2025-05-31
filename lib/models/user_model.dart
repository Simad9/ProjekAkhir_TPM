class User {
  final String username;
  final String email;
  final String passwordHash;
  final bool? sudah_bayar;
  final String? waktu_bayar;

  User({
    required this.username,
    required this.email,
    required this.passwordHash,
    this.sudah_bayar,
    this.waktu_bayar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'],
    email: json['email'],
    passwordHash: json['passwordHash'],
    sudah_bayar: json['sudah_bayar'],
    waktu_bayar: json['waktu_bayar'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'passwordHash': passwordHash,
    'sudah_bayar': sudah_bayar,
    'waktu_bayar': waktu_bayar,
  };
}
