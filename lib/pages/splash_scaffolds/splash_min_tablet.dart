// import 'package:flutter/material.dart';
//
// class MinTabletSplashScaffold extends StatelessWidget {
//   const MinTabletSplashScaffold({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.pinkAccent,
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class TabletSplashScaffold extends StatelessWidget {
//   const TabletSplashScaffold({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.yellowAccent,
//       body: Center(
//         child: Text(
//           "HELLOW HOW ARE U",
//           style: TextStyle(
//             fontSize: 50,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/pages/auth/login_page.dart';
import 'package:flutter_real_estate/pages/home_page.dart';

class MinTabletSplashScaffold extends StatefulWidget {
  const MinTabletSplashScaffold({super.key});

  @override
  State<MinTabletSplashScaffold> createState() => _MinTabletSplashScaffoldState();
}

class _MinTabletSplashScaffoldState extends State<MinTabletSplashScaffold> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Define a linear animation from 0 to 1
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the animation
    _controller.forward();

    // Move to the next screen when the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        changeToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          /// Background image that covers the whole screen
          Positioned.fill(
            child: Image.asset(
              "images/aerial-many-housses-green.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Overlay with reduced opacity
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75), // Adjust opacity here
            ),
          ),

          /// Centered text and progress bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'UNCAPTURED \nREAL-ESTATE', // Main text
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, // Text color to contrast with the overlay
                        fontSize: 45,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'The full-service software to handle real-estate and securable, available and fast working ', // Secondary text
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white54, // Text color to contrast with the overlay
                        fontSize: 18,
                        fontWeight: FontWeight.normal
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: 200, // Width of the progress bar
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _animation.value,
                          backgroundColor: Colors.grey[300],
                          color: kbuttonNewColor,
                        );
                      },
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
