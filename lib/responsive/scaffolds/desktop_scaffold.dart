import 'package:flutter/material.dart';
import 'package:flutter_real_estate/components/dashboard_link.dart';
import 'package:flutter_real_estate/fragments/dashboard_fragment.dart';
import 'package:flutter_real_estate/fragments/property_fragment.dart';
import 'package:flutter_real_estate/fragments/tenant_fragment.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  int pageIndex = 2;
  bool active = false;

  List _screens = [
    const DashboardFragment(),
    const PropertyUnityFragment(),
    TenantFragment(),
  ];

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
                // Space
                const SizedBox(
                  height: 55,
                ),

                // Create New Button
                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        // Ensures the text is centered and has enough padding
                      ),
                      child: const Text(
                        "+ Create New",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ensures text is visible
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // Links (You can add more here)
                DashboardLink(
                  icon: Icons.speed_outlined,
                  text: "Dashboard",
                  isActive: active,
                  changeIndex: () => {
                    setState(() {
                      pageIndex = 0;
                    }),
                  }
                ),

                DashboardLink(
                  icon: Icons.warehouse_outlined,
                  text: "Properties / Units",
                  isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 1;
                      }),
                    }
                ),

                DashboardLink(
                  icon: Icons.people_alt_outlined,
                  text: "Tenants",
                  isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 2;
                      }),
                    }
                ),

                DashboardLink(
                  icon: Icons.insert_drive_file_sharp,
                  text: "Lease",
                    isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 3;
                      }),
                    }
                ),

                DashboardLink(
                  icon: Icons.money,
                  text: "Collections",
                    isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 4;
                      }),
                    }
                ),

                DashboardLink(
                  icon: Icons.build,
                  text: "Maintenance",
                    isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 5;
                      }),
                    }
                ),

                const Spacer(),

                DashboardLink(
                  icon: Icons.settings,
                  text: "Settings",
                    isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 6;
                      }),
                    }
                ),

                DashboardLink(
                  icon: Icons.account_circle,
                  text: "Profile",
                    isActive: active,
                    changeIndex: () => {
                      setState(() {
                        pageIndex = 7;
                      }),
                    }
                ),




              ],
            ),
          ),

          // Contents (To be added later)
          _screens[pageIndex],
        ],
      ),
    );
  }
}