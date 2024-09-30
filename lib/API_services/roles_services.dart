import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<String>> allRoles(BuildContext context) async {
  const String baseUrl = "http://127.0.0.1:8000/api";

  try {
    final response = await http.get(Uri.parse("$baseUrl/auth-roles"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<String>((role) => role['role_name'] as String).toList();
    } else {
      throw Exception("Failed to load roles. Status code: ${response.statusCode}");
    }

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //
    //   // Filter out "Admin" and map the remaining roles to a list of role names
    //   return data
    //       .where((role) => role['role_name'] != 'Admin') // Exclude "Admin"
    //       .map<String>((role) => role['role_name'] as String)
    //       .toList();
    // } else {
    //   throw Exception("Failed to load roles. Status code: ${response.statusCode}");
    // }

  } catch (e) {
    throw Exception('Failed to load roles');
  }
}
