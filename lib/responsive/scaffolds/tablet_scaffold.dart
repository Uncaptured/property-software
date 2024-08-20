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
      SettingsFragment(),
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
                onPressFunction: () {},
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

                 SizedBox(
                   height: MediaQuery.of(context).size.height * 0.5,
                 ),

                 _buildDrawerItem(
                     icon: Icons.settings,
                     text: 'Setting',
                     index: 7,
                     context: context
                 ),

                 _buildDrawerItem(
                     icon: Icons.account_circle,
                     text: 'Profile',
                     index: 8,
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
