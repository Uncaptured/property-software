import 'package:intl/intl.dart';

class AllUnityModel{
  final int id;
  final String name;
  final String beds;
  final String baths;
  final String sqm;
  final String price;
  final int property_id;
  final String created_at;

  AllUnityModel({
    required this.id,
    required this.name,
    required this.beds,
    required this.baths,
    required this.sqm,
    required this.price,
    required this.property_id,
    required this.created_at
  });

  factory AllUnityModel.fromJson(Map<String, dynamic> json){
    return AllUnityModel(
        id: json['id'],
        name: json['unity_name'],
        beds: json['unity_beds'],
        baths: json['unity_baths'],
        sqm: json['sqm'],
        price: json['unity_price'],
        property_id: json['property_id'],
        created_at: json['created_at']
    );
  }

  /// FORMAT PRICE TO THOUSANDS
  String get formatPrice {
    final NumberFormat formatter = NumberFormat('#,##0');
    return formatter.format(int.parse(price));
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