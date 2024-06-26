import 'package:booking_app/Data/secure_storage.dart';
import 'package:booking_app/Pages/login_page.dart';
import 'package:booking_app/Pages/profile_page.dart';
import 'package:booking_app/api_connection/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pair/pair.dart';
import 'package:restart_app/restart_app.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../widgets/post_item.dart';
import 'create_post_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final apiService = GetIt.instance<APIService>();
  final secureStorage = GetIt.instance<SecureStorage>();
  late User user;

  List<Post>? posts = [];

  Future<List<Post>?> fillPosts() async {
    user = await secureStorage.getUser();
    Pair<int, List<Post>?> pair = await apiService.getAllPosts(user);
    print(2);
    if(pair.key == 200){
      print(3);
      posts = pair.value;
      return posts;
    }
    else if(pair.key == 401){
      await secureStorage.removeUser();
      print('amogus?');
      Restart.restartApp();
      print('Why');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лента'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePostPage()),
            ).then((value) => {
              setState((){
                apiService.getAllPosts(user);
              })
            }),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>?>(
        future: fillPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  // Отобразите каждый пост
                  return PostItem(post: post); // Используйте ваш PostItem виджет
                },
              );
            }
            else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }

        }
      )
    );
  }
}

