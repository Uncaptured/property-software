import 'package:intl/intl.dart';


class Roles{
  final int id;
  final String name;
  final String description;
  final String create_at;

  Roles({
    required this.id,
    required this.name,
    required this.description,
    required this.create_at
  });

  factory Roles.fromJson(Map<String, dynamic> json){
    return Roles(
        id: json['id'],
        name: json['role_name'],
        description: json['description'],
        create_at: json['created_at']
    );
  }

  /// UPDATE DATE = CREATE_AT to FORMATTED DATE
  String get formattedDate {
    DateTime dateTime = DateTime.parse(create_at);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  /// UPDATE DATE = CREATE_AT to TIME-AGO
  String get timeAgo {
    DateTime dateTime = DateTime.parse(create_at);
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

