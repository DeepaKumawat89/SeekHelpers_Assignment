//------------------------------------ User Model Class ------------------------------------//
class User {
  //------------------------------------ Properties ------------------------------------//
  final int? id;
  final String name;
  final String email;
  final String phone;

  //------------------------------------ Constructor ------------------------------------//
  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  //------------------------------------ JSON Converters ------------------------------------//
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
  };
}
