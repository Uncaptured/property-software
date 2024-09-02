import 'package:flutter/material.dart';

class MyNewPinkButton extends StatelessWidget {
  final double width;
  final String title;
  final Function? onPressFunction;

  const MyNewPinkButton({
    super.key,
    required this.width,
    required this.title,
    required this.onPressFunction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (onPressFunction != null) {
            onPressFunction!(); // Call the function
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 17,
          ), // Add padding to button
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
