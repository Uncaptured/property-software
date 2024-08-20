// import 'package:flutter/material.dart';
//
// class MinTabletRegScaffold extends StatelessWidget {
//   const MinTabletRegScaffold({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class TabletRegScaffold extends StatelessWidget {
//   const TabletRegScaffold({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/auth_services.dart';
import 'package:flutter_real_estate/components/form_select_input.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/components/reg_form_input.dart';
import 'package:flutter_real_estate/components/reg_select_form_input.dart';
import 'package:flutter_real_estate/pages/auth/login_page.dart';

class MinTabletRegScaffold extends StatelessWidget {
  MinTabletRegScaffold({super.key});

  // Initialize the service
  final authService = AuthApiService();

  // Input controllers
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerUser(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    if (
    _firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _roleController.text.isEmpty ||
        _passwordController.text.isEmpty
    ) {
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are required");
    } else {
      final response = await authService.registerUser({
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role_id': _roleController.text,
        'password': _passwordController.text
      });

      Navigator.pop(context); // Close the loading indicator

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        showSuccessMsg(context, "Successfully Registered");
      } else {
        showErrorMsg(context, "Failed User Registration");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [

                  // Image.asset(
                  //   'svgs/user-sitting-auth.png',
                  //   fit: BoxFit.cover,
                  //   width: MediaQuery.of(context).size.width * 0.17,
                  //   height: 300,
                  // ),

                  // const SizedBox(width: 20),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // 650
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // Title text
                          const Text(
                            "ACCOUNT SIGNUP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black, // Ensure the text color is visible
                            ),
                          ),
                          const SizedBox(height: 25),

                              MyRegFormInput(
                                controller: _firstnameController,
                                isPassword: false,
                                title: "FirstName",
                              ),

                          const SizedBox(height: 20),

                              MyRegFormInput(
                                controller: _lastnameController,
                                isPassword: false,
                                title: "LastName",
                              ),

                          const SizedBox(height: 20),

                          MyRegFormInput(
                            controller: _emailController,
                            isPassword: false,
                            title: "Email Address",
                          ),

                          const SizedBox(height: 20),

                              MyRegFormInput(
                                controller: _phoneController,
                                isPassword: false,
                                title: "Phone",
                              ),

                              const SizedBox(height: 20),

                              MyRegSelectFormInput(
                                controller: _roleController,
                                isPassword: false,
                                title: "Role",
                              ),


                          const SizedBox(height: 20),

                          MyRegFormInput(
                            controller: _passwordController,
                            isPassword: true,
                            title: "Password",
                          ),

                          const SizedBox(height: 28),

                          MyNewPinkButton(
                            width: 300,
                            title: "Sign Up",
                            onPressFunction: () => _registerUser(context),
                          ),

                          const SizedBox(height: 25),

                          // Login link
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black), // Ensure visibility
                              children: [
                                const TextSpan(
                                  text: "Already Registered? ",
                                ),
                                TextSpan(
                                  text: 'Login',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginPage()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
