import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/dashboard_link.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/fragments/admin_fragment.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/profile_fragment.dart';
import 'package:flutter_real_estate/fragments/property_fragment.dart';
import 'package:flutter_real_estate/fragments/role_fragment.dart';
import 'package:flutter_real_estate/fragments/tenant_fragment.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/fragments/lease_fragment.dart';
import 'package:flutter_real_estate/fragments/maintenance_fragment.dart';
import 'package:flutter_real_estate/fragments/settings_fragment.dart';
import 'package:flutter_real_estate/fragments/unity_fragment.dart';
import '../../fragments/collections_fragment.dart';
import '../../fragments/user_fragment.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {

  bool active = false;
  int pageIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardFragment(onSelectPage: _selectPage),
      PropertyFragment(),
      const UnityFragment(),
      TenantFragment(),
      LeaseFragment(),
      CollectionFragment(),
      MaintenanceFragment(),
      UserFragment(),
      AdminFragment(),
      RoleFragment(),
      SettingsFragment(),
      ProfileFragment()
    ];
  }

  void _selectPage(int index) {
    setState(() {
      if (index >= 0 && index < _screens.length) {
        pageIndex = index;
      }
    });
  }

  void _showDialogCreateNew(){
    showDialog(
        context: context,
        builder: (context) => const MyCreateNewDialog(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          // Sidebar
          Container(
            width: 250,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0Xff334277),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [

                const SizedBox(height: 18),

                MyNewPinkButton(
                    width: 300,
                    title: "+ Create New",
                    onPressFunction: _showDialogCreateNew
                ),

                const SizedBox(height: 27),

                DashboardLink(
                  icon: Icons.speed_outlined,
                  text: "Dashboard",
                  isActive: pageIndex == 0, // Active when pageIndex is 0
                  changeIndex: () {
                    _selectPage(0);
                  },
                ),
                DashboardLink(
                  icon: Icons.apartment_outlined,
                  text: "Properties",
                  isActive: pageIndex == 1, // Active when pageIndex is 1
                  changeIndex: () {
                    _selectPage(1);
                  },
                ),
                DashboardLink(
                  icon: Icons.door_front_door_outlined,
                  text: "Units",
                  isActive: pageIndex == 2, // Active when pageIndex is 2
                  changeIndex: () {
                    _selectPage(2);
                  },
                ),
                DashboardLink(
                  icon: Icons.people_alt_outlined,
                  text: "Tenants",
                  isActive: pageIndex == 3, // Active when pageIndex is 3
                  changeIndex: () {
                    _selectPage(3);
                  },
                ),
                DashboardLink(
                  icon: Icons.insert_drive_file_sharp,
                  text: "Lease",
                  isActive: pageIndex == 4, // Active when pageIndex is 4
                  changeIndex: () {
                    _selectPage(4);
                  },
                ),
                DashboardLink(
                  icon: Icons.monetization_on,
                  text: "Collections",
                  isActive: pageIndex == 5, // Active when pageIndex is 5
                  changeIndex: () {
                    _selectPage(5);
                  },
                ),
                DashboardLink(
                  icon: Icons.build,
                  text: "Maintenance",
                  isActive: pageIndex == 6, // Active when pageIndex is 6
                  changeIndex: () {
                    _selectPage(6);
                  },
                ),

                DashboardLink(
                  icon: Icons.person,
                  text: "Users",
                  isActive: pageIndex == 7, // Active when pageIndex is 6
                  changeIndex: () {
                    _selectPage(7);
                  },
                ),

                DashboardLink(
                  icon: Icons.person_add_alt_rounded,
                  text: "Admins",
                  isActive: pageIndex == 8, // Active when pageIndex is 6
                  changeIndex: () {
                    _selectPage(8);
                  },
                ),

                DashboardLink(
                  icon: Icons.account_tree,
                  text: "Roles",
                  isActive: pageIndex == 9, // Active when pageIndex is 6
                  changeIndex: () {
                    _selectPage(9);
                  },
                ),


                const Spacer(),

                DashboardLink(
                  icon: Icons.settings,
                  text: "Settings",
                  isActive: pageIndex == 10, // Active when pageIndex is 7
                  changeIndex: () {
                    _selectPage(10);
                  },
                ),
                DashboardLink(
                  icon: Icons.account_circle,
                  text: "Profile",
                  isActive: pageIndex == 11, // Active when pageIndex is 8
                  changeIndex: () {
                    _selectPage(11);
                  },
                ),

              ],
            ),
          ),

          _screens[pageIndex],
        ],
      ),
    );
  }
}



class MyCreateNewDialog extends StatefulWidget {
  const MyCreateNewDialog({super.key});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 160), // Padding on sides
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.77,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 50,
                ), // Internal padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Head
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Text
                          const Text(
                            "Create New",
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
                    ),

                    // Divider line
                    Container( // Make it take the full width
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                      ),
                    ),

                    const SizedBox(height: 30,),

                    Wrap(
                      spacing: 40, // Horizontal space between columns
                      runSpacing: 40, // Vertical space between rows
                      children: [
                        buildColumn("Property", [
                          buildIconButton(Icons.apartment, "Add New Property", (){}),
                        ]),
                        buildColumn("People", [
                          buildIconButton(Icons.people, "Add New User", (){}),
                          buildIconButton(Icons.people, "Add New Tenant", (){}),
                        ]),
                        buildColumn("Collections", [
                          buildIconButton(Icons.monetization_on, "Add Collection", (){}),
                        ]),
                        buildColumn("Maintenance", [
                          buildIconButton(Icons.build, "New Request", (){}),
                        ]),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  // Column Button
  Widget buildColumn(String title, List<Widget> buttons) {
    return SizedBox(
      width: 200, // Adjust width to fit your design needs
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ...buttons, // Add the list of buttons to the column
        ],
      ),
    );
  }




  // Helper method to create an icon button with text
  Widget buildIconButton(IconData icon, String text, Function()? onTapFunction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTapFunction,
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
