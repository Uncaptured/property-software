import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/auth/login/desktop_login_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/min_tablet_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/mobile_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/tablet_login_scaffold.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileScaffold: MobileLoginScaffold(),
        tabletScaffold: TabletLoginScaffold(),
        desktopScaffold: DesktopLoginScaffold(),
        mintabletscaffold: MinTabletLoginScaffold()
    );
  }
}
