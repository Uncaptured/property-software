import 'package:flutter/material.dart';

class MyFormInput extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final String title;

  // constructor
  const MyFormInput({
    super.key,
    required this.icon,
    required this.controller,
    required this.isPassword,
    required this.title,
  });

  @override
  State<MyFormInput> createState() => _MyFormInputState();
}

class _MyFormInputState extends State<MyFormInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          hintText: widget.title,
          icon: Icon(
            widget.icon,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
