import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/all_lease_model.dart';
import 'dart:typed_data';


class AllLeaseService{
  final String baseUrl = "http://127.0.0.1:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final List<AllLeaseModel> _leases = [];


    Future<List<AllLeaseModel>> getAllLease() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all-lease"),
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((lease) => AllLeaseModel.fromJson(lease)).toList();
    }else{
      throw Exception("Error fetch All Lease");
    }
  }


  // Future<http.Response> createLease({
  //   required String startDate,
  //   required String endDate,
  //   required String ammount,
  //   required dynamic document, // Accepts either File or Uint8List
  //   required String documentName, // For naming the file
  //   required String frequency,
  //   required String tenant_id,
  // }) async {
  //   final token = await storage.read(key: 'auth_token');
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse("$baseUrl/create-lease"),
  //   );
  //
  //   // Adding fields
  //   request.fields['startDate'] = startDate;
  //   request.fields['endDate'] = endDate;
  //   request.fields['ammount'] = ammount;
  //   request.fields['frequency'] = frequency;
  //   request.fields['tenant_id'] = tenant_id;
  //
  //   // Adding document
  //   if (document is Uint8List) {
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'document',
  //         document,
  //         filename: documentName,
  //       ),
  //     );
  //   } else if (document is File) {
  //     request.files.add(
  //       http.MultipartFile(
  //         'document',
  //         document.readAsBytes().asStream(),
  //         document.lengthSync(),
  //         filename: documentName,
  //       ),
  //     );
  //   }
  //
  //   // Adding headers
  //   request.headers['Authorization'] = 'Bearer $token';
  //
  //   // Sending request
  //   try {
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //
  //     // Debugging response
  //     print("Response status: ${response.statusCode}");
  //     print("Response body: ${response.body}");
  //
  //     return response;
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     rethrow;
  //   }
  // }
  //


  Future<http.Response> createLease({
    required String startDate,
    required String endDate,
    required String ammount,
    required dynamic document, // Accepts either File or Uint8List
    required String documentName, // For naming the file
    required String frequency,
    required String tenant_id,
  }) async {
    final token = await storage.read(key: 'auth_token');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/create-lease"),
    );

    // Adding fields
    request.fields['startDate'] = startDate;
    request.fields['endDate'] = endDate;
    request.fields['ammount'] = ammount;
    request.fields['frequency'] = frequency;
    request.fields['tenant_id'] = tenant_id;

    // Adding document
    if (document is Uint8List) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'document',
          document,
          filename: documentName,
        ),
      );
    } else if (document is File) {
      request.files.add(
        http.MultipartFile(
          'document',
          document.readAsBytes().asStream(),
          document.lengthSync(),
          filename: documentName,
        ),
      );
    }

    // Adding headers
    request.headers['Authorization'] = 'Bearer $token';

    // Sending request
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Debugging response
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return response;
    } catch (e) {
      print("Error occurred: $e");
      rethrow;
    }
  }




  Future<http.Response> deleteLease(int id) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
        Uri.parse('$baseUrl/delete-lease/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );
    return response;
  }




  // Future<http.Response> updateLease({
  //   required String id,
  //   required String startDate,
  //   required String endDate,
  //   required String ammount,
  //   required dynamic document, // Accepts either File or Uint8List
  //   required String documentName, // For naming the file
  //   required String frequency,
  //   required bool isChanged,
  //   required String tenant_id,
  // }) async {
  //   final token = await storage.read(key: 'auth_token');
  //   if(isChanged == true){
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse("$baseUrl/update-lease"),
  //     );
  //
  //     // Adding fields
  //     request.fields['id'] = id;
  //     request.fields['startDate'] = startDate;
  //     request.fields['endDate'] = endDate;
  //     request.fields['ammount'] = ammount;
  //     request.fields['frequency'] = frequency;
  //     request.fields['tenant_id'] = tenant_id;
  //
  //     // Adding document
  //     if (document is Uint8List) {
  //       request.files.add(
  //         http.MultipartFile.fromBytes(
  //           'document',
  //           document,
  //           filename: documentName,
  //         ),
  //       );
  //     } else if (document is File) {
  //       request.files.add(
  //         http.MultipartFile(
  //           'document',
  //           document.readAsBytes().asStream(),
  //           document.lengthSync(),
  //           filename: documentName,
  //         ),
  //       );
  //     }
  //
  //     request.headers['Authorization'] = 'Bearer $token';
  //
  //     try {
  //       var streamedResponse = await request.send();
  //       var response = await http.Response.fromStream(streamedResponse);
  //
  //       print("Response status: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //
  //       return response;
  //     } catch (e) {
  //       print("Error occurred: $e");
  //       rethrow;
  //     }
  //   }
  //   else{
  //     final response = await http.post(
  //         Uri.parse('$baseUrl/update-lease'),
  //         body: jsonEncode({
  //           'id': id,
  //           'startDate': startDate,
  //           'endDate': endDate,
  //           'ammount': ammount,
  //           'frequency': frequency,
  //           'tenant_id': tenant_id,
  //         }),
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         }
  //       );
  //     return response;
  //   }
  // }


  Future<http.Response> updateLease({
    required String id,
    required String startDate,
    required String endDate,
    required String ammount,
    required dynamic document, // Accepts either File or Uint8List
    required String documentName, // For naming the file
    required String frequency,
    required bool isChanged,
    required String tenant_id,
  }) async {
    final token = await storage.read(key: 'auth_token');

    if (isChanged == true) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/update-lease"),
      );

      // Adding fields
      request.fields['id'] = id;
      request.fields['startDate'] = startDate;
      request.fields['endDate'] = endDate;
      request.fields['ammount'] = ammount;
      request.fields['frequency'] = frequency;
      request.fields['tenant_id'] = tenant_id;

      // Adding document (either Uint8List or File)
      if (document is Uint8List) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'document',
            document,
            filename: documentName,
          ),
        );
      } else if (document is File) {
        request.files.add(
          http.MultipartFile(
            'document',
            document.readAsBytes().asStream(),
            document.lengthSync(),
            filename: documentName,
          ),
        );
      }

      request.headers['Authorization'] = 'Bearer $token';

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        return response;
      } catch (e) {
        print("Error occurred: $e");
        rethrow;
      }
    } else {
      // If the document hasn't changed, send a normal POST request
      final response = await http.post(
        Uri.parse('$baseUrl/update-lease'),
        body: jsonEncode({
          'id': id,
          'startDate': startDate,
          'endDate': endDate,
          'ammount': ammount,
          'frequency': frequency,
          'tenant_id': tenant_id,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response;
    }
  }

}