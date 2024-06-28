import 'package:booking_app/Data/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pair/pair.dart';
import 'package:restart_app/restart_app.dart';
import '../models/user.dart';
import '../api_connection/api_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  final secureStorage = GetIt.instance.get<SecureStorage>();
  final apiService = GetIt.instance.get<APIService>();

  Future<User> _loadUserData() async {
    user = await secureStorage.getUser();
    Pair<int, User> apiResponse = await apiService.getUser(user);
    if(apiResponse.key == 200) {
      user.imageLink = apiResponse.value.imageLink;
    }
    else{
      print('Сервер прислал код: ${apiResponse.key}');
    }
    return user;
  }
  void _logout() {
    secureStorage.removeUser();
    Restart.restartApp();
  }

  // Показывает диалоговое окно для загрузки новой аватарки
  void _showAvatarUploadDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        final _newAvatarUrlController = TextEditingController();
        return AlertDialog(
          title: const Text('Загрузить новую аватарку'),
          content: TextField(
            controller: _newAvatarUrlController,
            decoration: const InputDecoration(hintText: 'Введите ссылку на аватарку'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                int status = await apiService.updateUser(user, _newAvatarUrlController.text);
                if(status == 200){
                  setState(() {
                    user.imageLink = _newAvatarUrlController.text;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Загрузить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: FutureBuilder<User>(
        future: _loadUserData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            user = snapshot.data!;
            return Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.imageLink),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _showAvatarUploadDialog,
                        child: const Text('Изменить аватарку'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    user.login,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Выйти'),
                  ),
                ],
            );
          }
          else if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }
          else{
            return const CircularProgressIndicator();
          }
        }
      ),
    );
  }
}