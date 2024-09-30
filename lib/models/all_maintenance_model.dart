
import 'package:intl/intl.dart';

class AllMaintenanceModel{

  final int id;
  final int property_id;
  final String subject;
  final String description;
  final String item;
  final String status;
  final String price;
  final String created_at;

  AllMaintenanceModel({
    required this.id,
    required this.property_id,
    required this.subject,
    required this.item,
    required this.price,
    required this.description,
    required this.status,
    required this.created_at
  });

  factory AllMaintenanceModel.fromJson(Map<String, dynamic> json){
    return AllMaintenanceModel(
        id: json['id'],
        property_id: json['property_id'],
        subject: json['subject'],
        description: json['description'],
        item: json['item'],
        price: json['price'],
        status: json['status'],
        created_at: json['created_at'],
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