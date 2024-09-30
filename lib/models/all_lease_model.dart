import 'package:intl/intl.dart';

class AllLeaseModel{
  final int id;
  final String startDate;
  final String endDate;
  final int unity_id;
  final int property_id;
  final int tenant_id;
  final String frequency;
  final String document;
  final String ammount;
  final String created_at;

  AllLeaseModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.unity_id,
    required this.property_id,
    required this.tenant_id,
    required this.frequency,
    required this.document,
    required this.ammount,
    required this.created_at
  });

  factory AllLeaseModel.fromJson(Map<String, dynamic> json){
    return AllLeaseModel(
        id: json['id'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        unity_id: json['unity_id'],
        property_id: json['property_id'],
        tenant_id: json['property_id'],
        frequency: json['frequency'],
        document: json['document'],
        ammount: json['ammount'],
        created_at: json['created_at']
    );
  }

  /// FORMAT PRICE TO THOUSANDS
  String get formatPrice {
    final NumberFormat formatter = NumberFormat('#,##0');
    return formatter.format(int.parse(ammount));
  }

  String get formattedToNameMonth {
    DateTime dateTime = DateTime.parse(created_at);
    return DateFormat('MMM dd, yyyy').format(dateTime);
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