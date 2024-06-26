import 'dart:convert';
import 'dart:core';

import '../models/post.dart';
import '../models/user.dart';

class MyJsonDecoder{
  static List<Post> jsonToListOfPost(String responseBody){
    List<Post> posts = [];
    final parsedJson = jsonDecode(responseBody);

    for(int i = 0; i < parsedJson.length; i++){
      final prePost = parsedJson[i];
      User owner = User(id: prePost['owner']['id'], imageLink: prePost['owner']['imageLink'],
                        login: prePost['owner']['login'], password: prePost['owner']['password']);
      Post post = Post(id: prePost['id'], name: prePost['name'], text: prePost['text'], owner: owner);
      posts.add(post);
    }

    return posts;
  }
}