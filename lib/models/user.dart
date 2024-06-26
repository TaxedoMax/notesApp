class User {
  int id = 0;
  String login = "";
  String password = "";
  String imageLink = "";

  User({
    required this.id,
    required this.login,
    required this.password,
    required this.imageLink
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      login: json['name'] as String,
      password: json['password'] as String,
      imageLink: json['imageLink'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'password': password,
      'imageLink': imageLink
    };
  }
}