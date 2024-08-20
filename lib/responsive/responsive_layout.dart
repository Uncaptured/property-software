import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {

  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;
  final Widget mintabletscaffold;

  const ResponsiveLayout({
    super.key,
    required this.mobileScaffold,
    required this.tabletScaffold,
    required this.desktopScaffold,
    required this.mintabletscaffold
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth < 500){
        return mobileScaffold;
      } else if(constraints.maxWidth < 700){
        return mintabletscaffold;
      } else if(constraints.maxWidth < 1100){
        return tabletScaffold;
      }else{
        return desktopScaffold;
      }
    });
  }
}
