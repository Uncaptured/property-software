import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardFragment extends StatelessWidget {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // head
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RichText(
              textAlign: TextAlign.start,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Hi Dave \n"
                    ),
                    TextSpan(
                      text: "Welcome Back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
            ),
          ),



          // divider line
          Container(
            width: 1100,
            height: 1,
            margin: EdgeInsets.only(left: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade500
            ),
          ),



          // row - boxes
           const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
             children: [

               BoxProgress(title: "Collections", count: 20,),

               SizedBox(width: 30,),

               BoxProgress(title: "Maintenance Request", count: 40,),

               SizedBox(width: 30,),

               BoxProgress(title: "Users", count: 10,),

             ],
            ),
          ),

        ],
      ),
    );
  }
}


class BoxProgress extends StatelessWidget {

  final String title;
  final int count;

  const BoxProgress({
    super.key,
    required this.title,
    required this.count
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 130,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title
          ),
           Text(
            "$count",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}
