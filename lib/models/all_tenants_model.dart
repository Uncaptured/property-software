import 'package:intl/intl.dart';

class AllTenantsModel{
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String? company_name;
  final int unity_id;
  final String status;
  final String created_at;

  AllTenantsModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    this.company_name,
    required this.status,
    required this.unity_id,
    required this.created_at
  });

  factory AllTenantsModel.fromJson(Map<String, dynamic> json){
    return AllTenantsModel(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        phone: json['phone'],
        company_name: json['company_name'],
        unity_id: json['unity_id'],
        status: json['status'],
        created_at: json['created_at']
    );
  }

  /// UPDATE DATE => CREATE_AT to FORMATTED DATE
  String get formattedDate {
    DateTime dateTime = DateTime.parse(created_at);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  /// UPDATE DATE = CREATE_AT to TIME-AGO
  String get timeAgo {
    DateTime dateTime = DateTime.parse(created_at);
    final Duration difference = DateTime.now().difference(dateTime);

    if(difference.inDays > 0){
      return "${difference.inDays} days ago";
    } else if(difference.inHours > 0){
      return "${difference.inHours} hours ago";
    }else if(difference.inMinutes > 0){
      return "${difference.inMinutes} min ago";
    }else if(difference.inSeconds > 0){
      return "${difference.inSeconds} sec ago";
    }else{
      return "just now";
    }
  }
}