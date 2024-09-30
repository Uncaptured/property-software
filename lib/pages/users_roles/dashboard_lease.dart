import 'package:flutter/material.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';
import 'lease_scaffolds/desktop_lease_scaffold.dart';
import 'lease_scaffolds/mintable_lease_scaffold.dart';
import 'lease_scaffolds/mobile_lease_scaffold.dart';
import 'lease_scaffolds/tablet_lease_scaffold.dart';

class DashboardLeasePage extends StatelessWidget {
  const DashboardLeasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileLeaseScaffold(),
      tabletScaffold: TabletLeaseScaffold(),
      desktopScaffold: DesktopLeaseScaffold(),
      mintabletscaffold: MinTabletLeaseScaffold(),
    );
  }
}
