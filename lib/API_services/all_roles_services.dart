import 'dart:convert';
import 'package:flutter_real_estate/models/roles_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class RolesService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<Roles> _roles = [];

  Future<List<Roles>> getAllRoles() async {
   final response = await http.get(Uri.parse("$baseUrl/roles"));

   if(response.statusCode == 200){
     final List<dynamic> data = jsonDecode(response.body);
     return data.map((role) => Roles.fromJson(role)).toList();
   }else{
     throw Exception('Failed to Load Roles');
   }
  }


  Future<http.Response> sendRole(Map<String, dynamic> rolesData) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
      Uri.parse("$baseUrl/add-role"),
      body: jsonEncode(rolesData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }



  Future<http.Response> deleteRole(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/delete-role/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }
    );

    return response;
  }


  Future<http.Response> updateRoleService(Map<String, dynamic> rolesUpdateData) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
        Uri.parse('$baseUrl/update-role'),
        body: jsonEncode(rolesUpdateData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );

    return response;
  }
  
}