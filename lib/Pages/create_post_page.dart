import 'package:booking_app/Data/secure_storage.dart';
import 'package:booking_app/api_connection/api_service.dart';
import 'package:booking_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/post.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final apiService = GetIt.instance.get<APIService>();
  final secureStorage = GetIt.instance.get<SecureStorage>();

  void _createPost() async {
    if(_titleController.text.isNotEmpty && _titleController.text != ""
        && _contentController.text.isNotEmpty && _contentController.text != ""){
      User user = await secureStorage.getUser();
      Post post = Post(name: _titleController.text, text: _contentController.text,
                  id: 0, owner: User(id: 0, login: "", password: "", imageLink: ""));

      int status = await apiService.sendPost(user, post);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать пост'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Название поста',
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Текст поста',
                ),
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}