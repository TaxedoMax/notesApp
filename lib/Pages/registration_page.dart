import 'dart:io';

import 'package:booking_app/Data/secure_storage.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:get_it/get_it.dart';
import 'package:booking_app/api_connection/api_service.dart';
import 'package:booking_app/models/user.dart';

import 'home_page.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final apiService = GetIt.instance.get<APIService>();
  final secureStorage = GetIt.instance.get<SecureStorage>();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if(_loginController.text.isNotEmpty || _loginController.text != '' &&
        _passwordController.text.isNotEmpty || _passwordController.text != '' &&
        _confirmPasswordController.text == _passwordController.text){

      final user = User(id: 0,
                        login: _loginController.text,
                        password: _passwordController.text,
                        imageLink: "");
      int status;

      status = await apiService.registerUser(user);

      if(status == 200){
        await secureStorage.saveUser(user);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HomePage(),
          ),
        );
      }
      else if(status == 409){
        // Логин существует
          showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Пользователь с таким именем уже существует'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Неизвестная ошибка. Попробуйте позже.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Заголовок
              const Text(
                'Регистрация',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),

              // Поле для ввода имени
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Поле для ввода пароля
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль должен быть не менее 6 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Поле для подтверждения пароля
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Подтвердите пароль',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Повторите пароль';
                  }
                  if (_passwordController.text != value) {
                    return 'Пароли не совпадают';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),

              // Кнопка "Зарегистрироваться"
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    registerUser();
                  }
                },
                child: const Text('Зарегистрироваться'),
              ),
              const SizedBox(height: 16.0),

              // Кнопка "Войти"
              TextButton(
                onPressed: () {
                  // Переход на страницу авторизации
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}