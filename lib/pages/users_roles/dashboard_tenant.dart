import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/users_roles/tenant_scaffolds/desktop_tenant_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/tenant_scaffolds/mintable_tenant_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/tenant_scaffolds/mobile_tenant_scaffold.dart';
import 'package:flutter_real_estate/pages/users_roles/tenant_scaffolds/tablet_tenant_scaffold.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class DashboardTenantPage extends StatelessWidget {
  const DashboardTenantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileTenantScaffold(),
      tabletScaffold: TabletTenantScaffold(),
      desktopScaffold: DesktopTenantScaffold(),
      mintabletscaffold: MinTabletTenantScaffold(),
    );
  }
}
