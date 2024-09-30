import 'dart:convert';
import 'package:flutter_real_estate/models/auth_user.dart';
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


  Future<http.Response> loginUser(Map<String, dynamic> loginUserData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login-user"),
      body: jsonEncode(loginUserData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the response body
      final responseData = jsonDecode(response.body);

      final token = responseData['token'];
      final userJson = responseData['staff'];

      if (userJson != null && userJson is Map<String, dynamic>) {
        AuthUser.instance.updateFromJson(userJson); // Update the singleton instance
      } else {
        print('Error: Invalid user data format');
      }

      // Store the token securely (if needed)
      await storage.write(key: 'auth_token', value: token);

      print("Login successful. User data: ${AuthUser.instance.toJson()}"); // For debugging
    } else {
      print("Login failed. Status code: ${response.statusCode}");
    }

    return response;
  }


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

    if (response.statusCode == 200) {
      await storage.delete(key: 'auth_token');
    }

    return response;
  }

  // UPDATE USER DATA
  Future<http.Response> updateUserData(userData) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse("$baseUrl/update-user-profile"),
      body: jsonEncode(userData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }

}
