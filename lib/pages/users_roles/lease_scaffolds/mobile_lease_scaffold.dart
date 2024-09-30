import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/lease_fragment.dart';
import 'package:flutter_real_estate/fragments/profile_fragment.dart';

class MobileLeaseScaffold extends StatefulWidget {
  const MobileLeaseScaffold({super.key});

  @override
  State<MobileLeaseScaffold> createState() => _MobileLeaseScaffoldState();
}

class _MobileLeaseScaffoldState extends State<MobileLeaseScaffold> {
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardFragment(onSelectPage: _selectPage),
      LeaseFragment(),
      ProfileFragment()
    ];
  }

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
    return Scaffold(
      key: _scaffoldKey,  // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();  // Use the key to open the drawer
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0Xff334277),
        child: Column(
          children: <Widget>[

            const SizedBox(height: 40,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyNewPinkButton(onPressFunction: _showDialogCreateNew, width: 300, title: '+ Create New',),
            ),

            const SizedBox(height: 15,),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[

                  ListTile(
                    leading: Icon(Icons.speed, color: Colors.grey.shade400,),
                    title: Text('Dashboard', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(0);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.apartment_outlined, color: Colors.grey.shade400,),
                    title: Text('Properties', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(1);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.door_front_door_outlined, color: Colors.grey.shade400,),
                    title: Text('Units', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(2);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.grey.shade400,),
                    title: Text('Tenants', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(3);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.grey.shade400,),
                    title: Text('Lease', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(4);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on, color: Colors.grey.shade400,),
                    title: Text('Collections', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(5);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.build, color: Colors.grey.shade400,),
                    title: Text('Maintenance', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(6);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.grey.shade400,),
                    title: Text('Users', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(7);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_tree, color: Colors.grey.shade400,),
                    title: Text('Roles', style: TextStyle(color: Colors.grey.shade300)),
                    onTap: () {
                      _selectPage(8);
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey.shade400,),
              title: Text('Settings', style: TextStyle(color: Colors.grey.shade300)),
              onTap: () {
                _selectPage(9);
                Navigator.pop(context); // Close the drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.grey.shade400,),
              title: Text('Profile', style: TextStyle(color: Colors.grey.shade300)),
              onTap: () {
                _selectPage(10);
                Navigator.pop(context); // Close the drawer
              },
            ),

          ],
        ),
      ),

      body: _screens[pageIndex],
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20), // Padding on sides
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.77,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
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
