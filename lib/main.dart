import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/home_page.dart';
import 'package:flutter_real_estate/pages/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: const HomePage(),
      // home: const SplashScreen(),
    );
  }
}
