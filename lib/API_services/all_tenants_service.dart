import 'dart:convert';

import 'package:flutter_real_estate/models/all_tenants_model.dart';
import 'package:flutter_real_estate/models/all_users_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AllTenantsService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<AllTenantsModel> _tenants = [];


  Future<List<AllTenantsModel>> getAllTenants() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-tenants"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((tenant) => AllTenantsModel.fromJson(tenant)).toList();
    }else{
      throw Exception("Error fetch All Tenants");
    }
  }


  Future<http.Response> createTenant(Map<String, dynamic> tenantData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-tenant"),
      body: jsonEncode(tenantData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }



  // Future<http.Response> deleteUser(int id) async {
  //   final token = await storage.read(key: 'auth_token');
  //
  //   final response = await http.get(
  //       Uri.parse('$baseUrl/delete-user/$id'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       }
  //   );
  //
  //   return response;
  // }
  //
  //
  // Future<http.Response> updateUserData(Map<String, dynamic> usersData) async {
  //   final token = await storage.read(key: 'auth_token');
  //
  //   final response = await http.post(
  //       Uri.parse('$baseUrl/update-user'),
  //       body: jsonEncode(usersData),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       }
  //   );
  //   return response;
  // }



}