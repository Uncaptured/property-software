import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';



class FormUpdatePassword extends StatelessWidget {
  const FormUpdatePassword({
    super.key,
    required TextEditingController oldPasswordController,
    required TextEditingController newPasswordController,
    required TextEditingController confirmPasswordController,
    required this.onTapFunction
  }) : _oldPasswordController = oldPasswordController, _newPasswordController = newPasswordController, _confirmPasswordController = confirmPasswordController;

  final TextEditingController _oldPasswordController;
  final TextEditingController _newPasswordController;
  final TextEditingController _confirmPasswordController;
  final Function()? onTapFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          const SizedBox(height: 20,),

          TextField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(
              labelText: "Old Password",
            ),
          ),

          const SizedBox(height: 15,),

          TextField(
            controller: _newPasswordController,
            decoration: const InputDecoration(
              labelText: "New Password",
            ),
          ),

          const SizedBox(height: 15,),

          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
            ),
          ),

          const SizedBox(height: 20,),

          MyNewPinkButton(
              width: 200,
              title: "Update Password",
              onPressFunction: onTapFunction
          ),

          const SizedBox(height: 15,),
        ],
      ),
    );
  }
}
