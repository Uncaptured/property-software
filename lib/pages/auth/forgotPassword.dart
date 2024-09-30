import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/auth/forgotPassword/desktop_forgotPassword_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/forgotPassword/minTable_forgotPassword_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/forgotPassword/mobile_forgotPassword_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/forgotPassword/tablet_forgotPassword_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/desktop_login_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/min_tablet_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/mobile_scaffold.dart';
import 'package:flutter_real_estate/pages/auth/login/tablet_login_scaffold.dart';
import 'package:flutter_real_estate/responsive/responsive_layout.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobileScaffold: MobileForgotpasswordScaffold(),
        tabletScaffold: TabletForgotpasswordScaffold(),
        desktopScaffold: DesktopForgotpasswordScaffold(),
        mintabletscaffold: MinTabletForgotpasswordScaffold()
    );
  }
}
