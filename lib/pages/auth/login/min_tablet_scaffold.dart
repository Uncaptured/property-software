import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_real_estate/API_services/auth_services.dart';
import 'package:flutter_real_estate/components/form_input.dart';
import 'package:flutter_real_estate/components/form_select_input.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/pages/auth/signup_page.dart';
import 'package:flutter_real_estate/API_services/roles_services.dart';
import 'package:flutter_real_estate/pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MinTabletLoginScaffold extends StatefulWidget {
  const MinTabletLoginScaffold({super.key});

  @override
  State<MinTabletLoginScaffold> createState() => _MinTabletLoginScaffoldState();
}

class _MinTabletLoginScaffoldState extends State<MinTabletLoginScaffold> {
  // INITIALIZE SERVICES && STORAGE
  final storage = const FlutterSecureStorage();

  late AuthApiService authService;
  late Future<List<String>> _rolesFuture;

  bool isLoading = true;  // To manage loading state

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

  // input controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // function LOGIN USER
  void _loginUser(BuildContext context) async {
    if (_emailController.text.isEmpty ||
        _roleController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showErrorMsg(context, "All Fields are Required");
    } else {
      final response = await authService.loginUser({
        'email': _emailController.text,
        'role_id': _roleController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
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
      body: isLoading
          ?
            const Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: Center(
          child: Container(
            height: 550,
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
                  rolesFuture: _rolesFuture, // Pass the future for roles here
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
                const SizedBox(height: 25),
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
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
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
      ),
    );
  }
}
