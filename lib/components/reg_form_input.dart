import 'package:flutter/material.dart';


class MyRegFormInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String title;
  final List<String>? options;  // Add this to pass options for dropdown
  final bool isDropdown;  // Flag to identify if it's a dropdown

  const MyRegFormInput({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.title,
    this.options,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: isDropdown && options != null
          ? DropdownButtonFormField<String>(
        value: options!.isNotEmpty ? options![0] : null,
        items: options!.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.text = newValue!;
        },
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
        ),
      )
          : TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
