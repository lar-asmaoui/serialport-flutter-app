class User {
  int? id;
  String? username;
  String? password;
  String? role;

  User({
    this.id,
    this.username,
    this.password,
    this.role,
  });

  Map<String, dynamic> toJson() => {
        'username': username.toString(),
        'password': password.toString(),
        'role': role.toString()
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: int.parse(json['id']),
      username: json['username'],
      role: json['role']);
}
