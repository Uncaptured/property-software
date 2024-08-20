import 'package:flutter/material.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';
import 'package:flutter_real_estate/responsive/scaffolds/desktop_scaffold.dart';
import 'package:flutter_real_estate/responsive/scaffolds/mintable_scaffold.dart';
import 'package:flutter_real_estate/responsive/scaffolds/mobile_scaffold.dart';
import 'package:flutter_real_estate/responsive/scaffolds/tablet_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: MobileScaffold(),
      mintabletscaffold: MinTabletScaffold(),
      tabletScaffold: TabletScaffold(),
      desktopScaffold: DesktopScaffold(),
    );
  }
}
