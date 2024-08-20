import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/dashboard_link.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/lease_fragment.dart';
import 'package:flutter_real_estate/fragments/maintenance_fragment.dart';
import 'package:flutter_real_estate/fragments/property_fragment.dart';
import 'package:flutter_real_estate/fragments/settings_fragment.dart';
import 'package:flutter_real_estate/fragments/tenant_fragment.dart';
import 'package:flutter_real_estate/fragments/unity_fragment.dart';
import '../../fragments/collections_fragment.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  int pageIndex = 0;

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
      if (index >= 0 && index < _screens.length) {
        pageIndex = index;
      }
    });
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
                    onPressFunction: () {}),
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
                const Spacer(),
                DashboardLink(
                  icon: Icons.settings,
                  text: "Settings",
                  isActive: pageIndex == 7, // Active when pageIndex is 7
                  changeIndex: () {
                    _selectPage(7);
                  },
                ),
                DashboardLink(
                  icon: Icons.account_circle,
                  text: "Profile",
                  isActive: pageIndex == 8, // Active when pageIndex is 8
                  changeIndex: () {
                    _selectPage(8);
                  },
                ),
              ],
            ),
          ),

          // Contents (Add Expanded to ensure it takes available space)
          _screens[pageIndex],
        ],
      ),
    );
  }
}
