import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/auth/forgotPassword.dart';
import 'package:flutter_real_estate/pages/auth/login_page.dart';
import 'package:flutter_real_estate/pages/users_roles/dashboard_collections.dart';
import 'package:flutter_real_estate/pages/users_roles/dashboard_properties.dart';
import 'package:flutter_real_estate/pages/users_roles/dashboard_tenant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../API_services/auth_services.dart';
import '../../../API_services/roles_services.dart';
import '../../../components/form_input.dart';
import '../../../components/form_select_input.dart';
import '../../../components/notification.dart';
import '../../../components/pink_new_button.dart';
import '../../home_page.dart';
import '../../users_roles/dashboard_maintenance.dart';
import '../signup_page.dart';


class DesktopLoginScaffold extends StatefulWidget {
  const DesktopLoginScaffold({super.key});

  @override
  State<DesktopLoginScaffold> createState() => _DesktopLoginScaffoldState();
}

class _DesktopLoginScaffoldState extends State<DesktopLoginScaffold> {
  final storage = const FlutterSecureStorage();
  late AuthApiService authService;
  late Future<List<String>> _rolesFuture;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = true;  // To manage loading state
  bool isLogin = false;
  bool isSecured = true;

  @override
  void initState() {
    super.initState();
    authService = AuthApiService();
    _fetchRoles();
  }

  void _isLoadingState(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  void _fetchRoles() async {
    setState(() {
      isLoading = true;
    });

    _rolesFuture = allRoles(context);

    _rolesFuture.then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showErrorMsg(context, "Failed to load roles");
    });
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }

      } else if (response.statusCode == 400) {
        showErrorMsg(context, "Validation Error");
      } else if (response.statusCode == 401) {
        showErrorMsg(context, "Auth Error, Invalid Credentials");
      } else {
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
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'svgs/user-sitting-auth.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.17,
                      height: 300,
                    ),

                    const SizedBox(width: 20),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4),
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
                                  style:
                                  const TextStyle(color: Colors.blueAccent),
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
        ],
      ),
    );
  }
}
