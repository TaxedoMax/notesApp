import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class SecureStorage{
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveUser(User user) async {
    await _storage.write(key: 'login', value: user.login);
    await _storage.write(key: 'password', value: user.password);
  }

  Future<void> removeUser() async{
    await _storage.delete(key: 'login');
    await _storage.delete(key: 'password');
  }

  Future<User> getUser() async {
    final login = await _storage.read(key: 'login');
    final password = await _storage.read(key: 'password');

    if (login != null && password != null) {
      return User(login: login, password: password, imageLink: '', id: 0);
    } else {
      return User(login: '', password: '', imageLink: '', id: 0);
    }
  }
}