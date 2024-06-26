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
            'Host': 'localhost:8080'
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
      print(response.statusCode);
      if(response.statusCode == 200){
        print(1);
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
      print(response.body);
      return Pair(response.statusCode, int.parse(response.body));
    } on Exception catch(e){
      print(e.toString());
      return const Pair(-1, -1);
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