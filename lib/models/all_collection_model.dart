import 'package:intl/intl.dart';

class AllCollectionModel{
  final int id;
  final int property_id;
  final String subject;
  final String description;
  final String type;
  final String status;
  final String ammount;
  final String created_at;

  AllCollectionModel({
    required this.id,
    required this.property_id,
    required this.subject,
    required this.type,
    required this.description,
    required this.status,
    required this.ammount,
    required this.created_at
  });

  factory AllCollectionModel.fromJson(Map<String, dynamic> json){
    return AllCollectionModel(
      id: json['id'],
      property_id: json['property_id'],
      subject: json['subject'],
      type: json['type'],
      description: json['description'],
      ammount: json['ammount'],
      status: json['status'],
      created_at: json['created_at'],
    );
  }


  /// FORMAT PRICE TO THOUSANDS
  String get formatPrice {
    final NumberFormat formatter = NumberFormat('#,##0');
    return formatter.format(int.parse(ammount));
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