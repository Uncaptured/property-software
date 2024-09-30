import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';



class FormProfileDetails extends StatelessWidget {
  const FormProfileDetails({
    super.key,
    required TextEditingController firstnameController,
    required TextEditingController lastnameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required this.onPressFunction
  }) : _firstnameController = firstnameController, _lastnameController = lastnameController, _emailController = emailController, _phoneController = phoneController;

  final TextEditingController _firstnameController;
  final TextEditingController _lastnameController;
  final TextEditingController _emailController;
  final TextEditingController _phoneController;
  final Function()? onPressFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          TextField(
            controller: _firstnameController,
            decoration: const InputDecoration(
              labelText: "FirstName",
            ),
          ),

          const SizedBox(height: 15,),

          TextField(
            controller: _lastnameController,
            decoration: const InputDecoration(
              labelText: "LastName",
            ),
          ),

          const SizedBox(height: 15,),

          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email Address",
            ),
          ),

          const SizedBox(height: 15,),

          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: "Phone Number",
            ),
          ),

          const SizedBox(height: 20,),

          MyNewPinkButton(
              width: 200,
              title: "Update Profile",
              onPressFunction: onPressFunction
          ),

        ],
      ),
    );
  }
}
