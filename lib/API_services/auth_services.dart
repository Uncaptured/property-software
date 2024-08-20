import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Register User
  Future<http.Response> registerUser(Map<String, dynamic> userRegisterData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register-user"),
      body: jsonEncode(userRegisterData),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  // Login User and Store Token
  Future<http.Response> loginUser(Map<String, dynamic> loginUserData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login-user"),
      body: jsonEncode(loginUserData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Assuming the response body contains a JSON object with a token field
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      // Store the token securely
      await storage.write(key: 'auth_token', value: token);
    }

    return response;
  }

  // Example of making an authenticated request using the stored token
  Future<http.Response> getProtectedData() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$baseUrl/protected-route"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  // Logout User and Clear Token
  Future<http.Response> logoutUser() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse("$baseUrl/logout-user"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // if(response.statusCode == 200){
    //   await storage.delete(key: 'auth_token');
    //   return response;
    // }

    return response;
  }
}
