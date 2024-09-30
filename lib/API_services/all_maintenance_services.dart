import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/all_lease_model.dart';
import 'dart:typed_data';

import '../models/all_maintenance_model.dart';


class AllMaintenanceService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<AllMaintenanceModel> _maintenances = [];


  Future<List<AllMaintenanceModel>> getAllMaintenance() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-maintenance"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((maintenance) => AllMaintenanceModel.fromJson(maintenance)).toList();
    }else{
      throw Exception("Error, fetching All Maintenance");
    }
  }


  Future<http.Response> createMaintenance(Map<String, dynamic> maintenanceData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/create-maintenance"),
      body: jsonEncode(maintenanceData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<http.Response> deleteMaintenance(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-maintenance/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }




  Future<http.Response> updateMaintenance(Map<String, dynamic> maintenanceData) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
        Uri.parse('$baseUrl/update-maintenance'),
        body: jsonEncode(maintenanceData),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }


}