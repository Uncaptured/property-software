import 'package:flutter/material.dart';


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
    required this.changeIndex
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeIndex,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey.withOpacity(0.4) : Colors.transparent,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [

            // icon
            Icon(
              icon,
              color: Colors.white,),

            const SizedBox(width: 10,),

            // text
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
