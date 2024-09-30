import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/dashboard_link.dart';
import 'package:flutter_real_estate/fragments/profile_fragment.dart';
import 'package:flutter_real_estate/pages/users_roles/user_dashboards_fragment/user_maintenance_dashboard_fragment.dart';
import 'package:flutter_real_estate/pages/users_roles/users_fragments_pages/user_maintenance_fragment.dart';


class DesktopMaintenanceScaffold extends StatefulWidget {
  const DesktopMaintenanceScaffold({super.key});

  @override
  State<DesktopMaintenanceScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopMaintenanceScaffold> {

  bool active = false;
  int pageIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      UserMaintenanceDashboardFragment(onSelectPage: _selectPage),
      UserMaintenanceFragment(),
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

                const SizedBox(height: 18),

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
                  icon: Icons.build,
                  text: "Maintenance",
                  isActive: pageIndex == 1, // Active when pageIndex is 6
                  changeIndex: () {
                    _selectPage(1);
                  },
                ),

                DashboardLink(
                  icon: Icons.account_circle,
                  text: "Profile",
                  isActive: pageIndex == 2, // Active when pageIndex is 8
                  changeIndex: () {
                    _selectPage(2);
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
