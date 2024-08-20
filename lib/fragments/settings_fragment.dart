import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/settings_block_links.dart';

class SettingsFragment extends StatelessWidget {
  SettingsFragment({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Head
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "General Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),


              // Divider line
              Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                ),
              ),


              const SizedBox(height: 20),


              const Text(
                "Personal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 10),

              const Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [

                  // Boxes
                  SettingsLinks(
                    image: "svgs/icon-svg-account.png",
                    title: "Personal Information",
                    description: "Change your, name, email, & phone",
                  ),

                  // Boxes
                  SettingsLinks(
                    image: "svgs/icon-svg-password.png",
                    title: "Login & Password",
                    description: "Change your, email & Password",
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Company",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 10),

              // Wrap with spacing and auto wrap
              const Wrap(
                spacing: 20, // Horizontal spacing between items
                runSpacing: 20, // Vertical spacing between rows
                children: [

                  SettingsLinks(
                    image: "svgs/icon-svg-company.png",
                    title: "Company Information",
                    description: "Company Name, Address",
                  ),

                  SettingsLinks(
                    image: "svgs/icon-svg-user.png",
                    title: "Users",
                    description: "Add or Edit Users",
                  ),

                  SettingsLinks(
                    image: "svgs/icon-user-id.png",
                    title: "User Roles",
                    description: "Allow or block Access for each user.",
                  ),

                  SettingsLinks(
                    image: "svgs/icon-svg-phone-money.png",
                    title: "Subscription",
                    description: "Add or Edit users",
                  ),

                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
