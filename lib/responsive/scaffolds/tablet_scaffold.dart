import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/fragments/collections_fragment.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/lease_fragment.dart';
import 'package:flutter_real_estate/fragments/maintenance_fragment.dart';
import 'package:flutter_real_estate/fragments/profile_fragment.dart';
import 'package:flutter_real_estate/fragments/property_fragment.dart';
import 'package:flutter_real_estate/fragments/settings_fragment.dart';
import 'package:flutter_real_estate/fragments/tenant_fragment.dart';
import 'package:flutter_real_estate/fragments/unity_fragment.dart';
import 'package:flutter_real_estate/fragments/user_fragment.dart';


class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _selectPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void _showDialogCreateNew(){
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => const MyCreateNewDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardFragment(
        onSelectPage: (int index) {
          _selectPage(index);
        },
      ),
      PropertyFragment(),
      UnityFragment(),
      TenantFragment(),
      LeaseFragment(),
      CollectionFragment(),
      MaintenanceFragment(),
      UserFragment(),
      SettingsFragment(),
      ProfileFragment()
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0Xff334277),
        child: Column(
          children: <Widget>[

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyNewPinkButton(
                onPressFunction: _showDialogCreateNew,
                width: 300,
                title: '+ Create New',
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[

                  _buildDrawerItem(
                      icon: Icons.speed,
                      text: 'Dashboard',
                      index: 0,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.apartment_outlined,
                      text: 'Properties',
                      index: 1,
                      context: context),

                  _buildDrawerItem(
                      icon: Icons.door_front_door_outlined,
                      text: 'Units',
                      index: 2,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.person,
                      text: 'Tenants',
                      index: 3,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.receipt_long,
                      text: 'Lease',
                      index: 4,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.monetization_on,
                      text: 'Collection',
                      index: 5,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.build,
                      text: 'Maintenance',
                      index: 6,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.person,
                      text: 'Users',
                      index: 7,
                      context: context
                  ),

                  _buildDrawerItem(
                      icon: Icons.account_tree,
                      text: 'Roles',
                      index: 8,
                      context: context
                  ),

                 SizedBox(
                   height: MediaQuery.of(context).size.height * 0.19,
                 ),

                 _buildDrawerItem(
                     icon: Icons.settings,
                     text: 'Setting',
                     index: 9,
                     context: context
                 ),

                 _buildDrawerItem(
                     icon: Icons.account_circle,
                     text: 'Profile',
                     index: 10,
                     context: context
                 ),

                ],
              ),
            ),
          ],
        ),
      ),

      body: _screens[pageIndex],

    );
  }



  ListTile _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade400),
      title: Text(text, style: TextStyle(color: Colors.grey.shade300)),
      onTap: () {
        _selectPage(index);
        Navigator.pop(context);
      },
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 100), // Padding on sides
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

