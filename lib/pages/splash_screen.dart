import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/splash_scaffolds/splash_desktop.dart';
import 'package:flutter_real_estate/pages/splash_scaffolds/splash_min_tablet.dart';
import 'package:flutter_real_estate/pages/splash_scaffolds/splash_mobile.dart';
import 'package:flutter_real_estate/pages/splash_scaffolds/splash_tablet.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobileScaffold: MobileSplashScaffold(),
        tabletScaffold: TabletSplashScaffold(),
        desktopScaffold: DesktopSplashScaffold(),
        mintabletscaffold: MinTabletSplashScaffold()
    );
  }
}
