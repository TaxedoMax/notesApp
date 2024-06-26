import 'dart:convert';

import 'package:booking_app/models/user.dart';
class BasicAuthBuilder{

  static String getAuthHeader(User user){
      final login = user.login;
      final password = user.password;
      final credentials = base64.encode(utf8.encode('$login:$password'));
      final authHeader = 'Basic $credentials';

      return authHeader;
    }
  }