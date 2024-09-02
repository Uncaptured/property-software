
import 'package:intl/intl.dart';

class AllPropertyModel{
  final int id;
  final String name;
  final String type;
  final String address;
  final String created_at;

  AllPropertyModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.created_at
  });


  factory AllPropertyModel.fromJson(Map<String, dynamic> json){
    return AllPropertyModel(
        id: json['id'],
        name: json['property_name'],
        type: json['property_type'],
        address: json['property_address'],
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

