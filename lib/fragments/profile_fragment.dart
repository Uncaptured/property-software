import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/auth_services.dart';
import 'package:flutter_real_estate/components/form_update_password.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/pages/auth/login_page.dart';
import '../components/form_update_form_details.dart';
import '../models/auth_user.dart';

class ProfileFragment extends StatefulWidget {
  ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final AuthUser user = AuthUser();
  final AuthApiService authApi = AuthApiService();

  void isLoadingState(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white,),
          );
        }
    );
  }

  Future<void> _updateUserData(int userId, String fname, String lname, String email, String phone) async {
    isLoadingState();
    if(userId.isNaN || fname.isEmpty || lname.isEmpty || email.isEmpty || phone.isEmpty){
        Navigator.pop(context);
        showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await authApi.updateUserData({
        'id':  userId,
        'firstname': fname,
        'lastname': lname,
        'email': email,
        'phone': phone
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        setState(() {
          // refresh the widget
        });
        user.updateFromJson({
          'id': userId,
          'firstname': fname,
          'lastname': lname,
          'email': email,
          'phone': phone,
        });
        showSuccessMsg(context, "Profile Details Updated Successfully");
      }else{
        showErrorMsg(context, "Profile Details Not-Updated");
      }

    }
  }


  Future<void> _userLogout() async {
    isLoadingState();
    final response = await authApi.logoutUser();
    if(response.statusCode == 200){
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _firstnameController = TextEditingController(text: user.firstname);
    TextEditingController _lastnameController = TextEditingController(text: user.lastname);
    TextEditingController _emailController = TextEditingController(text: user.email);
    TextEditingController _phoneController = TextEditingController(text: user.phone);
    TextEditingController _oldPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 30.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Head
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Text
                        const Text(
                          "My Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),


                        // Color mark
                        Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: kbuttonNewColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),


                      ],
                    ),

                  ],
                ),
              ),



              // Divider line
              Container( // Make it take the full width
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 30,),

              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(-4, 4),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(4, -4),
                        blurRadius: 10,
                      ),
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    const Text(
                      "Profile Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),

                    const SizedBox(height: 15,),

                    FormProfileDetails(
                      firstnameController: _firstnameController,
                      lastnameController: _lastnameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      onPressFunction: () => _updateUserData(
                          user.id,
                          _firstnameController.text,
                          _lastnameController.text,
                          _emailController.text,
                          _phoneController.text
                      ),
                    ),

                  ],
                ),
              ),


              const SizedBox(height: 45,),


              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(-4, 4),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(4, -4),
                        blurRadius: 10,
                      ),
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    const Text(
                      "Update Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),

                    FormUpdatePassword(
                        oldPasswordController: _oldPasswordController,
                        newPasswordController: _newPasswordController,
                        confirmPasswordController: _confirmPasswordController,
                        onTapFunction: (){}
                    ),


                  ],
                ),
              ),


              const SizedBox(height: 45,),


              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(-4, 4),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, -4),
                      blurRadius: 10,
                    ),
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),

                    const Text(
                      "On clicking this button below you will be sign Out of the Application and redirect\nto the login page, for login and signup if not have an account",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _userLogout,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 14,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            )
                        ),
                        child: const Row(
                          children: [
                            // icon
                            Icon(Icons.logout, color: Colors.white,),

                            SizedBox(width: 15,),

                            // text
                            Text("Logout", style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),


              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }
}
