import 'package:flutter/material.dart';



class ButtonDialogBox extends StatelessWidget {
  final String title;
  final Color color;
  final Function? onPressFunction;

  const ButtonDialogBox({
    super.key,
    required this.title,
    required this.color,
    required this.onPressFunction
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          if (onPressFunction != null) {
            onPressFunction!(); // Call the function
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            )
        ),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white
          ),
        )
    );
  }
}