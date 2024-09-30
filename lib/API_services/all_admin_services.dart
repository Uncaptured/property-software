import 'dart:convert';
import 'package:flutter_real_estate/models/all_admins_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AllAdminsService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<AllAdminsModel> _admins = [];


  Future<List<AllAdminsModel>> getAllAdmins() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-admins"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((admin) => AllAdminsModel.fromJson(admin)).toList();
    }else{
      throw Exception("Error fetch All Admins");
    }
  }


  Future<http.Response> createAdmin(Map<String, dynamic> adminData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-admin"),
      body: jsonEncode(adminData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }



  Future<http.Response> deleteAdmin(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-admin/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );

    return response;
  }


  Future<http.Response> updateAdminData(Map<String, dynamic> adminsData) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
        Uri.parse('$baseUrl/update-admin'),
        body: jsonEncode(adminsData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }

}