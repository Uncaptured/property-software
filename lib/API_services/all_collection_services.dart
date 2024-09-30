import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/all_collection_model.dart';


class AllCollectionService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<AllCollectionModel> _collections = [];


  Future<List<AllCollectionModel>> getAllCollection() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-collections"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((collection) => AllCollectionModel.fromJson(collection)).toList();
    }else{
      throw Exception("Error, fetching All Collections");
    }
  }





  Future<http.Response> createCollection(Map<String, dynamic> collectionData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-collection"),
      body: jsonEncode(collectionData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<http.Response> deleteCollection(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-collection/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }




  Future<http.Response> updateCollectionData(Map<String, dynamic> collectionData) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
        Uri.parse('$baseUrl/update-collection'),
        body: jsonEncode(collectionData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }


}