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
import '../../users_roles/dashboard_collections.dart';
import '../../users_roles/dashboard_maintenance.dart';
import '../../users_roles/dashboard_properties.dart';
import '../../users_roles/dashboard_tenant.dart';
import '../forgotPassword.dart';

class TabletLoginScaffold extends StatefulWidget {
  TabletLoginScaffold({super.key});

  @override
  State<TabletLoginScaffold> createState() => _TabletLoginScaffoldState();
}

class _TabletLoginScaffoldState extends State<TabletLoginScaffold> {
  final storage = const FlutterSecureStorage();
  late AuthApiService authService;

  late Future<List<String>> _rolesFuture;

  bool isLoading = true;  // To manage loading state
  bool isSecured = true;

  @override
  void initState() {
    super.initState();
    authService = AuthApiService();
    _fetchRoles();  // Fetch roles when initializing the state
  }

  void _fetchRoles() async {
    setState(() {
      isLoading = true;  // Show loading indicator
    });

    _rolesFuture = allRoles(context);

    // Await the roles and then hide the loading indicator
    _rolesFuture.then((value) {
      setState(() {
        isLoading = false;  // Hide loading indicator once roles are fetched
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;  // Hide loading indicator in case of error
      });
      showErrorMsg(context, "Failed to load roles");
    });
  }



  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _isLoadingState(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  void _loginUser(BuildContext context) async {
    _isLoadingState();
    if (_emailController.text.isEmpty ||
        _roleController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
      return;
    } else {
      final response = await authService.loginUser({
        'email': _emailController.text,
        'role_id': _roleController.text,
        'password': _passwordController.text,
      });
      Navigator.pop(context);
      if (response.statusCode == 200) {
        showSuccessMsg(context, "Login Successfully");
        if(_roleController.text == 'Maintenance'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardMaintenancePage()),
          );
        }else if(_roleController.text == 'Collections'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardCollectionsPage()),
          );
        }else if(_roleController.text == 'Admin'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }else if(_roleController.text == 'Tenants'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardTenantPage()),
          );
        }
        else if(_roleController.text == 'Property'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPropertyPage()),
          );
        }else{
          showErrorMsg(context, 'Role Not-Defined, Define in Login Methods');
        }
      } else if (response.statusCode == 400) {
        Navigator.pop(context);
        showErrorMsg(context, "Validation Error");
      } else if (response.statusCode == 401) {
        Navigator.pop(context);
        showErrorMsg(context, "Auth Error, Invalid Credentials");
      } else {
        Navigator.pop(context);
        showErrorMsg(context, "Email, Role, or Password is Incorrect");
      }
    }
  }


  void _changeHideAndViewPassword(){
    setState(() {
      isSecured = !isSecured;
    });
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
                        icon: Icons.account_tree,
                        title: "Role",
                        controller: _roleController,
                        isPassword: false,
                        rolesFuture: _rolesFuture,
                      ),

                      const SizedBox(height: 20),

                      MyFormInput(
                        icon: Icons.lock,
                        controller: _passwordController,
                        isPassword: isSecured,
                        title: "Password",
                        onTapHide: _changeHideAndViewPassword,
                        suffixIcon: isSecured ? Icons.visibility : Icons.visibility_off,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
                            ),
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
