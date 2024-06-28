import 'dart:io';
import 'dart:convert';

import 'package:pair/pair.dart';

import '../models/post.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:booking_app/api_connection/json_decoder.dart';

import 'basic_auth_builder.dart';

class APIService {
  final String _baseUrl;

  APIService(this._baseUrl);

  Future<int> login(User user) async {
    try{
      String auth = BasicAuthBuilder.getAuthHeader(user);
      final response = await http.get(Uri.parse('$_baseUrl/users/check_auth'),
          headers: {
            'Authorization': auth,
            'Content-Type': 'application/json',
            'Host': _baseUrl
          });
      return response.statusCode;
    } on Exception catch(e){
      print(e.toString());
      return 400;
    }
  }
  Future<int> registerUser(User user) async {
    try{
      final response = await http.post(Uri.parse('$_baseUrl/users/reg'),
        headers: {
          'Content-Type': 'application/json',
          'Host': 'localhost:8080'},
        body: jsonEncode(user.toJson()),
      );
      return response.statusCode;
    }
    on Exception catch(ex){
     print(ex.toString());
     return 400;
    }
  }

  Future<Pair<int, List<Post>?>> getAllPosts(User user) async{
    try{
      String auth = BasicAuthBuilder.getAuthHeader(user);
      final response = await http.get(Uri.parse('$_baseUrl/notes/all'),
          headers: {
            'Authorization': auth,
            'Content-Type': 'application/json',
            'Host': 'localhost:8080'
          });
      if(response.statusCode == 200){
        return Pair(200, MyJsonDecoder.jsonToListOfPost(response.body));
      }
      else if(response.statusCode == 401){
        return const Pair(401, []);
      }
      else{
        return Pair(response.statusCode, []);
      }
    } on Exception catch(e){
      print(e.toString());
      throw Exception('Exception');
    }
  }

  Future<Pair<int, User>> getUser(User user) async{
    try{
      String auth = BasicAuthBuilder.getAuthHeader(user);
      String login = user.login;
      final response = await http.get(Uri.parse('$_baseUrl/users/user/$login'),
          headers: {
            'Authorization': auth,
            'Content-Type': 'application/json',
            'Host': 'localhost:8080'
          });
      User fullUser = MyJsonDecoder.jsonToUser(response.body);
      return Pair(response.statusCode, fullUser);
    } on Exception catch(e){
      print(e.toString());
      return  Pair(-1, User(id: 0, login: '', password: '', imageLink: ''));
    }
  }

  Future<Pair<int, int>> getUserId(User user) async{
    try{
      String auth = BasicAuthBuilder.getAuthHeader(user);
      String login = user.login;
      final response = await http.get(Uri.parse('$_baseUrl/users/user_id/$login'),
          headers: {
            'Authorization': auth,
            'Content-Type': 'application/json',
            'Host': 'localhost:8080'
          });
      return Pair(response.statusCode, int.parse(response.body));
    } on Exception catch(e){
      print(e.toString());
      return const Pair(-1, -1);
    }
  }

  Future<int> updateUser(User user, String imageLink) async {
    try{
      String auth = BasicAuthBuilder.getAuthHeader(user);

      String login = user.login;
      final getIdResponse = await getUserId(user);
      final id = getIdResponse.value;
      user.id = id;
      user.imageLink = imageLink;
      print('this moment $id');
      final response = await http.put(Uri.parse('$_baseUrl/users/update'),
          headers: {
            'Authorization': auth,
            'Content-Type': 'application/json',
            'Host': 'localhost:8080'
          },
          body: jsonEncode(user.toJson()));
      print('bebra');
      return response.statusCode;
    } on Exception catch(e){
      print('amogus');
      print(e.toString());
      return 400;
    }
  }

  Future<int> sendPost(User user, Post post) async{
    try{
      Pair<int, int> pair = await getUserId(user);
      int id = 0;
      if(pair.key != 200) {
        throw Exception();
      }
      else {
        id = pair.value;
      }
      user.id = id;
      post.owner = user;
      String auth = BasicAuthBuilder.getAuthHeader(user);
      final response = await http.post(Uri.parse('$_baseUrl/notes/new'),
          headers: {
            'Authorization': auth,
            'Content-Type': 'application/json',
            'Host': 'localhost:8080'
          },
          body: jsonEncode(post.toJson()));
      return response.statusCode;
    } on Exception catch(e){
      print(e.toString());
      return 400;
    }
  }
}