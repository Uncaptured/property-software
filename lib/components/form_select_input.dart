import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/roles_services.dart';

class MyFormSelectInput extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final String title;

  const MyFormSelectInput({
    super.key,
    required this.icon,
    required this.controller,
    required this.isPassword,
    required this.title,
  });

  @override
  State<MyFormSelectInput> createState() => _MyFormSelectInput();
}

class _MyFormSelectInput extends State<MyFormSelectInput> {
  String? selectedRole; // Initialize this variable outside the build method

  late Future<List<String>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _rolesFuture = allRoles(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<List<String>>(
        future: _rolesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No roles available");
          } else {
            final roles = snapshot.data!;
            return DropdownButtonFormField<String>(
              value: selectedRole,
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedRole = value;
                  widget.controller.text = selectedRole ?? '';
                });
              },
              decoration: InputDecoration(
                hintText: widget.title,
                prefixIcon: Icon(
                  widget.icon,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            );
          }
        },
      ),
    );
  }
}
