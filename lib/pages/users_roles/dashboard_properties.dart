import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/users_roles/properties_scaffolds/desktop_properties_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/properties_scaffolds/mintable_properties_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/properties_scaffolds/mobile_properties_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/properties_scaffolds/tablet_properties_scaffold.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class DashboardPropertyPage extends StatelessWidget {
  const DashboardPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobilePropertiesScaffold(),
      tabletScaffold: TabletPropertiesScaffold(),
      desktopScaffold: DesktopPropertiesScaffold(),
      mintabletscaffold: MinTabletPropertiesScaffold(),
    );
  }
}
