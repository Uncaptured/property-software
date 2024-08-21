import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardFragment extends StatelessWidget {
  final Function(int) onSelectPage;

  const DashboardFragment({
    super.key,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 500) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: DashboardContents(onSelectPage: onSelectPage),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: DashboardContents(onSelectPage: onSelectPage),
      );
    });
  }
}

class DashboardContents extends StatelessWidget {
  const DashboardContents({
    super.key,
    required this.onSelectPage,
  });

  final Function(int p1) onSelectPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // head
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              children: [
                TextSpan(text: "Hi Dave \n"),
                TextSpan(
                  text: "Welcome Back",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        // divider line
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey.shade400),
          ),
        ),
        // row - boxes
        Wrap(
          spacing: 30, // Horizontal spacing between items
          runSpacing: 30, // Vertical spacing between lines
          children: [
            BoxProgress(
              title: "Collections",
              count: 20,
              icon: Icons.monetization_on,
              onTapFunction: () => onSelectPage(5), // Navigate to Collections
            ),
            BoxProgress(
              title: "Maintenance Request",
              count: 40,
              icon: Icons.build,
              onTapFunction: () => onSelectPage(6), // Navigate to Maintenance
            ),
            BoxProgress(
              title: "Tenants",
              count: 10,
              icon: Icons.people,
              onTapFunction: () => onSelectPage(3), // Navigate to Tenants
            ),
          ],
        ),
      ],
    );
  }
}




class BoxProgress extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback onTapFunction;

  const BoxProgress({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth;

        if (containerWidth < 620) {
          containerWidth = containerWidth * 0.67; // Adjust to available space
        } else {
          containerWidth = 300; // Fixed width for larger screens
        }

        return GestureDetector(
          onTap: onTapFunction, // Call the onTapFunction when the container is tapped
          child: Container(
            width: containerWidth,
            height: 140,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$count",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    Icon(
                      icon,
                      color: Colors.black12,
                      size: 70,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
