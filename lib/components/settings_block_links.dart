import 'package:flutter/material.dart';

class SettingsLinks extends StatelessWidget {
  final String image, title, description;

  const SettingsLinks({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Icon
          Image.asset(
            image,
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10),
          // Text - Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Head title
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.5,
                ),
                textAlign: TextAlign.start,
              ),
              // Description
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}