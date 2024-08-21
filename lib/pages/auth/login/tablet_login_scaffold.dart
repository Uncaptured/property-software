import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/auth_services.dart';
import 'package:flutter_real_estate/components/form_input.dart';
import 'package:flutter_real_estate/components/form_select_input.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/pages/auth/signup_page.dart';
import 'package:flutter_real_estate/pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../API_services/roles_services.dart';

class TabletLoginScaffold extends StatefulWidget {
  TabletLoginScaffold({super.key});

  @override
  State<TabletLoginScaffold> createState() => _TabletLoginScaffoldState();
}

class _TabletLoginScaffoldState extends State<TabletLoginScaffold> {
  // Initialize services and storage
  final storage = const FlutterSecureStorage();
  final authService = AuthApiService();

  // Declare a future for roles
  late Future<List<String>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _rolesFuture = allRoles(context); // Initialize roles fetching in initState
  }

  // Input controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // INITIALIZE SERVICES && STORAGE
  // final authService = AuthApiService();
  // final storage = const FlutterSecureStorage();
  //
  // Declare a future for roles
  // late Future<List<String>> _rolesFuture;
  //
  // input controllers
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _roleController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _rolesFuture = allRoles(context); // Initialize roles fetching in initState
  // }


  // Function to log in the user
  void _loginUser(BuildContext context) async {
    if (_emailController.text.isEmpty ||
        _roleController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showErrorMsg(context, "All Fields are Required");
    } else {
      final response = await authService.loginUser({
        'email': _emailController.text,
        'role_id': _roleController.text,
        'password': _passwordController.text, // Fixed this line
      });

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        showSuccessMsg(context, "Login Successfully");
      } else {
        showErrorMsg(context, "Email, Role, or Password is Incorrect");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 100),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.55),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "ACCOUNT LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 25),
                      MyFormInput(
                        icon: Icons.mail,
                        title: "Email Address",
                        controller: _emailController,
                        isPassword: false,
                      ),

                      const SizedBox(height: 20),

                      MyFormSelectInput(
                        icon: Icons.format_list_numbered_sharp,
                        title: "Role",
                        controller: _roleController,
                        isPassword: false,
                        rolesFuture: _rolesFuture, // Pass the future here
                      ),

                      const SizedBox(height: 20),

                      MyFormInput(
                        icon: Icons.lock,
                        controller: _passwordController,
                        isPassword: true,
                        title: "Password",
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MyNewPinkButton(
                        width: 300,
                        title: "Login",
                        onPressFunction: () => _loginUser(context),
                      ),
                      const SizedBox(height: 25),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "New Here? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const RegisterPage()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
