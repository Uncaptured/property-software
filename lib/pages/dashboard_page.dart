import 'package:flutter/material.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';
import 'package:flutter_real_estate/responsive/scaffolds/desktop_scaffold.dart';
import 'package:flutter_real_estate/responsive/scaffolds/mobile_scaffold.dart';
import 'package:flutter_real_estate/responsive/scaffolds/tablet_scaffold.dart';
import 'package:flutter_real_estate/responsive/scaffolds/mintable_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileScaffold(),
      tabletScaffold: TabletScaffold(),
      desktopScaffold: DesktopScaffold(),
      mintabletscaffold: MinTabletScaffold(),
    );
  }
}
