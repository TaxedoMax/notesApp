import 'package:booking_app/models/user.dart';

class Post {
  int id;
  String name;
  String text;
  User owner = User(id: 0, login: "", password: "", imageLink: "");

  Post({
    required this.id,
    required this.name,
    required this.text,
    required this.owner
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'] as int,
        name: json['name'] as String,
        text: json['text'] as String,
        owner: User.fromJson(json['owner'] as Map<String, dynamic>)
    );
  }

  static List<Post> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Post.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'text': text,
      'owner': owner!.toJson()
    };
  }
}
