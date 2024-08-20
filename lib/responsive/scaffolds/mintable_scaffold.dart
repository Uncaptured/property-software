import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/fragments/collections_fragment.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/lease_fragment.dart';
import 'package:flutter_real_estate/fragments/maintenance_fragment.dart';
import 'package:flutter_real_estate/fragments/property_fragment.dart';
import 'package:flutter_real_estate/fragments/settings_fragment.dart';
import 'package:flutter_real_estate/fragments/tenant_fragment.dart';
import 'package:flutter_real_estate/fragments/unity_fragment.dart';

class MinTabletScaffold extends StatefulWidget {
  const MinTabletScaffold({super.key});

  @override
  State<MinTabletScaffold> createState() => _MinTabletScaffoldState();
}

class _MinTabletScaffoldState extends State<MinTabletScaffold> {
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardFragment(onSelectPage: _selectPage),
      PropertyFragment(),
      UnityFragment(),
      TenantFragment(),
      LeaseFragment(),
      CollectionFragment(),
      MaintenanceFragment(),
      SettingsFragment()
    ];
  }

  void _selectPage(int index) {
    setState(() {
      pageIndex = index;
    });
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
              child: MyNewPinkButton(onPressFunction: (){}, width: 300, title: '+ Create New',),
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
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey.shade400,),
              title: Text('Settings', style: TextStyle(color: Colors.grey.shade300)),
              onTap: () {
                _selectPage(7);
                Navigator.pop(context); // Close the drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.grey.shade400,),
              title: Text('Profile', style: TextStyle(color: Colors.grey.shade300)),
              onTap: () {
                _selectPage(8);
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
