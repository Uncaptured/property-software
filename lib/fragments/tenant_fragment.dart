// import 'dart:html';
import 'package:flutter/material.dart';

class TenantFragment extends StatelessWidget {
  TenantFragment({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 30.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            // Head
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
                      // Text
                      const Text(
                        "Tenants",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
      
      
                      // Color mark
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade400,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
      
                    ],
                  ),


                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 30
                      )
                    ),
                    child: const Text(
                      "+ Create New",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white
                      ),
                    )
                  ),
                ],
              ),
            ),

      
            // Divider line
            Container( // Make it take the full width
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
              ),
            ),
      
      
            const SizedBox(height: 20,),
      
      
            // Search Box
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: SizedBox(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
      
      
          ],
        ),
      ),
    );
  }
}
