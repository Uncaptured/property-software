import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/users_roles/maintenance_scaffolds/desktop_maintenance_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/maintenance_scaffolds/mintable_maintenance_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/maintenance_scaffolds/mobile_maintenance_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/maintenance_scaffolds/tablet_maintenance_scaffold.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class DashboardMaintenancePage extends StatelessWidget {
  const DashboardMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileMaintenanceScaffold(),
      tabletScaffold: TabletMaintenanceScaffold(),
      desktopScaffold: DesktopMaintenanceScaffold(),
      mintabletscaffold: MinTabletMaintenanceScaffold(),
    );
  }
}
