import 'dart:convert';
import 'package:flutter_real_estate/models/all_units_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AllUnityServices{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<List<AllUnityModel>> getAllUnities() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-unities"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((unity) => AllUnityModel.fromJson(unity)).toList();
    }else{
      throw Exception("Error fetch All Unities");
    }
  }


  Future<http.Response> createUnity(Map<String, dynamic> unityData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-unity"),
      body: jsonEncode(unityData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<http.Response> updateUnityData(Map<String, dynamic> unityData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/update-unity"),
      body: jsonEncode(unityData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<http.Response> deleteUnity(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-unity/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }

}