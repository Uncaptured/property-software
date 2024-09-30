import 'package:flutter/material.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';
import 'collections_scaffolds/desktop_collections_scaffold.dart';
import 'collections_scaffolds/mintable_collections_scaffold.dart';
import 'collections_scaffolds/mobile_collections_scaffold.dart';
import 'collections_scaffolds/tablet_collections_scaffold.dart';

class DashboardCollectionsPage extends StatelessWidget {
  const DashboardCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileCollectionsScaffold(),
      tabletScaffold: TabletCollectionsScaffold(),
      desktopScaffold: DesktopCollectionsScaffold(),
      mintabletscaffold: MinTabletCollectionsScaffold(),
    );
  }
}
