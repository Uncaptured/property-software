import 'package:flutter/material.dart';

class CountApp extends StatefulWidget {
  const CountApp({super.key});

  @override
  State<CountApp> createState() => _CountAppState();
}

class _CountAppState extends State<CountApp> {

  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            id++;
          });
        },
        child: Text(
          '+'
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: Icon(Icons.menu),
        title: Text(
          "COUNT APP",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${id}",
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            Text("You have clicked me ${id} times"),
          ],
        ),
      ),
    );
  }
}
