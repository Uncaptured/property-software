import 'dart:convert';

import 'package:flutter_real_estate/models/all_users_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AllUsersService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<AllUsersModel> _users = [];


  Future<List<AllUsersModel>> getAllUsers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-users"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => AllUsersModel.fromJson(user)).toList();
    }else{
      throw Exception("Error fetch All Users");
    }
  }



  Future<http.Response> createUser(Map<String, dynamic> userData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-user"),
      body: jsonEncode(userData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }



  Future<http.Response> deleteUser(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-user/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );

    return response;
  }


  Future<http.Response> updateUserData(Map<String, dynamic> usersData) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
        Uri.parse('$baseUrl/update-user'),
        body: jsonEncode(usersData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }


  Future<http.Response> resetUserPassword(Map<String, dynamic> usersData) async {
    final response = await http.post(
        Uri.parse('$baseUrl/reset-user-password'),
        body: jsonEncode(usersData),
        headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

}