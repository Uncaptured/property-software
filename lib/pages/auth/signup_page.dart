import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/auth/register/desktop_reg_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/register/min_tablet_reg_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/register/mobile_reg_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/register/tablet_reg_scaffold.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileScaffold: MobileRegScaffold(),
        tabletScaffold: TabletRegScaffold(),
        desktopScaffold: DesktopRegScaffold(),
        mintabletscaffold: MinTabletRegScaffold()
    );
  }
}
