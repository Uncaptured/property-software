import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/dashboard_link.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/profile_fragment.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/fragments/lease_fragment.dart';

import '../user_dashboards_fragment/user_lease_fragment.dart';
import '../users_fragments_pages/user_lease_fragment.dart';

class DesktopLeaseScaffold extends StatefulWidget {
  const DesktopLeaseScaffold({super.key});

  @override
  State<DesktopLeaseScaffold> createState() => _DesktopLeaseScaffoldState();
}

class _DesktopLeaseScaffoldState extends State<DesktopLeaseScaffold> {

  bool active = false;
  int pageIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      UserLeaseDashboardFragment(onSelectPage: _selectPage),
      UserLeaseFragment(),
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
                  icon: Icons.insert_drive_file_sharp,
                  text: "Lease",
                  isActive: pageIndex == 4, // Active when pageIndex is 4
                  changeIndex: () {
                    _selectPage(4);
                  },
                ),

                DashboardLink(
                  icon: Icons.account_circle,
                  text: "Profile",
                  isActive: pageIndex == 10, // Active when pageIndex is 8
                  changeIndex: () {
                    _selectPage(10);
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
