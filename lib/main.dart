import 'package:booking_app/Data/secure_storage.dart';
import 'package:booking_app/api_connection/api_service.dart';
import 'package:flutter/material.dart';
import 'Pages/home_page.dart';
import 'Pages/login_page.dart';
import 'Pages/registration_page.dart';
import 'package:get_it/get_it.dart';

import 'models/user.dart';

void main() {

  final getIt = GetIt.instance;
  getIt.registerSingleton<APIService>(APIService('http://localhost:8080'));
  getIt.registerSingleton<SecureStorage>(SecureStorage());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Вместо `HomePage`
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false; // Инициализация флага

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Проверка статуса входа в систему
  }

  Future<void> checkLoginStatus() async {
    final secureStorage = GetIt.instance.get<SecureStorage>();
    User user = await secureStorage.getUser();
    isLoggedIn = user.login.isNotEmpty && user.login != ''; // Проверка флага
    setState(() {}); // Обновление состояния
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? HomePage() : LoginPage(); // Выбор страницы
  }
}



