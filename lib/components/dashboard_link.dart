import 'package:flutter/material.dart';
import 'package:flutter_real_estate/constants.dart';


class DashboardLink extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isActive;
  final Function()? changeIndex;

  const DashboardLink({
    super.key,
    required this.icon,
    required this.text,
    required this.isActive,
    required this.changeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeIndex,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? khoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [

            // icon
            Icon(
              icon,
              color: Colors.grey.shade300,
            ),

            const SizedBox(width: 10,),

            // text
            Text(
              text,
              style:  TextStyle(
              color: Colors.grey.shade300,
            ),
            ),

          ],
        ),
      ),
    );
  }
}
