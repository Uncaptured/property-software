import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/all_users_services.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/pages/auth/login_page.dart';
import '../../../components/pink_new_button.dart';

class DesktopForgotpasswordScaffold extends StatefulWidget {
  const DesktopForgotpasswordScaffold({super.key});

  @override
  State<DesktopForgotpasswordScaffold> createState() => _DesktopForgotpasswordScaffoldState();
}

class _DesktopForgotpasswordScaffoldState extends State<DesktopForgotpasswordScaffold> {

  bool isLoading = true;
  bool isSecured = true;

  final AllUsersService allUsersService = AllUsersService();

  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void isLoadingState(){
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white,),
          );
        }
    );
  }

  void _changeHideAndViewPassword(){
    setState(() {
      isSecured = !isSecured;
    });
  }


  Future<void> _resetUserPassword(BuildContext context) async {
    isLoadingState();
    if(
      _emailPhoneController.text.isEmpty ||
      _newPasswordController.text.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, 'All Fields are Required');
    }else{
      final response = await allUsersService.resetUserPassword({
        'EmailorPhone': _emailPhoneController.text.toString(),
        'password': _newPasswordController.text.toString()
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        showSuccessMsg(context, 'Password Reseted Successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
        );
      }else if(response.statusCode == 405){
        Navigator.pop(context);
        showErrorMsg(context, 'User Not-Found with Email/Phone: ${_emailPhoneController.text}');
      }else{
        Navigator.pop(context);
        showErrorMsg(context, 'Unsuccessful Resetting Password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(15),
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
                            "ACCOUNT RESET-PASSWORD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),

                          const SizedBox(height: 25),

                          MyFormInput(
                            icon: Icons.mail,
                            title: "Email Address / Phone",
                            controller: _emailPhoneController,
                            isPassword: false,
                          ),

                          const SizedBox(height: 20),

                          MyFormInput(
                            icon: Icons.lock,
                            controller: _newPasswordController,
                            isPassword: isSecured,
                            title: "New Password",
                            onTapHide: _changeHideAndViewPassword,
                            suffixIcon: isSecured ? Icons.visibility : Icons.visibility_off,
                          ),

                          const SizedBox(height: 20),

                          MyNewPinkButton(
                            width: 300,
                            title: "Reset Password",
                            onPressFunction: () => _resetUserPassword(context),
                          ),

                          const SizedBox(height: 25),

                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: "Already Registered?", style: TextStyle(color: Colors.white)),
                                TextSpan(
                                  text: 'Login',
                                  style:
                                  const TextStyle(color: Colors.blueAccent),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const LoginPage()
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



class MyFormInput extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final String title;
  final IconData? suffixIcon;
  final Function()? onTapHide;

  // constructor
  const MyFormInput({
    super.key,
    required this.icon,
    required this.controller,
    required this.isPassword,
    required this.title,
    this.onTapHide,
    this.suffixIcon
  });

  @override
  State<MyFormInput> createState() => _MyFormInputState();
}

class _MyFormInputState extends State<MyFormInput> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
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
            hintStyle: TextStyle(
              color: Colors.white70
            ),
            suffixIcon: widget.suffixIcon != null ?
            GestureDetector(
              onTap: widget.onTapHide,
              child: Icon(
                widget.suffixIcon!,
                color: Colors.grey,
              ),
            )
                : null,
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
