
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/all_property_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AllPropertyService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final List<AllPropertyModel> _properties = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<List<AllPropertyModel>> getAllProperties() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-properties"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((property) => AllPropertyModel.fromJson(property)).toList();
    }else{
      throw Exception("Error fetch All Properties");
    }
  }


  Future<http.Response> createProperty(Map<String, dynamic> propertyData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-propertyUnit"),
      body: jsonEncode(propertyData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<http.Response> updatePropertyData(Map<String, dynamic> propertyData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/update-property"),
      body: jsonEncode(propertyData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<http.Response> deleteProperty(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-property/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }


}