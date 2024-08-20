// import 'package:flutter/material.dart';
//
// class MobileLoginScaffold extends StatelessWidget {
//   const MobileLoginScaffold({super.key});
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
// class MinTabletLoginScaffold extends StatelessWidget {
//   const MinTabletLoginScaffold({super.key});
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
//
// class TabletLoginScaffold extends StatelessWidget {
//   const TabletLoginScaffold({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }


import 'dart:convert';
import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/auth_services.dart';
import 'package:flutter_real_estate/components/form_input.dart';
import 'package:flutter_real_estate/components/form_select_input.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/pages/auth/signup_page.dart';
import 'package:flutter_real_estate/API_services/roles_services.dart';
import 'package:flutter_real_estate/pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MobileLoginScaffold extends StatelessWidget {
  MobileLoginScaffold({super.key});

  // INITIALIZE SERVICES && STORAGE
  final authService = AuthApiService();
  final storage = const FlutterSecureStorage();

  // input controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // function LOGIN USER
  void _loginUser(BuildContext context) async{
    if(
    _emailController.text.isEmpty ||
        _roleController.text.isEmpty ||
        _passwordController.text.isEmpty
    ){
      showErrorMsg(context, "All Fields are Required");
    } else{
      final response = await authService.loginUser({
        'email': _emailController.text,
        'role_id': _roleController.text,
        'password': _passwordController,
      });

      if(response.statusCode == 200){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        showSuccessMsg(context, "Login Successfully");
      }else{
        showSuccessMsg(context, "Email, Role or Password isIncorrect");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 25,
        ),
        child: Center(  // Center the entire content
          child: Container(
            height: 550,
            padding: const EdgeInsets.symmetric(
              vertical: 35,
              horizontal: 20,
            ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(width: 25), // Add horizontal spacing

                // contents form
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.87), // Constrain width of the column
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

                      const SizedBox(height: 25,),

                      // login email
                      MyFormInput(
                          icon: Icons.mail,
                          title: "Email Address",
                          controller: _emailController,
                          isPassword: false
                      ),

                      const SizedBox(height: 20),

                      MyFormSelectInput(
                        icon: Icons.format_list_numbered_sharp,
                        title: "Role",
                        controller: _roleController,
                        isPassword: false,
                      ),

                      const SizedBox(height: 20),

                      // login password
                      MyFormInput(icon: Icons.lock, controller: _passwordController, isPassword: true, title: "Password"),

                      const SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          // forgot password
                          GestureDetector(
                            onTap: (){},
                            child: const Text(
                              "forgotPassword?",
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

                      const SizedBox(height: 25,),

                      RichText(
                        text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "New Here? ",
                              ),

                              TextSpan(
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RegisterPage())
                                    );
                                  }
                              ),

                            ]
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