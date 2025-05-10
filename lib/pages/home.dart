import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("data1"),
          Text("data2"),
          Text("Date3"),
          Text("data4"),
          Container(height: 200, width: double.infinity, color: Colors.orange),
        ],
      ),
    );
  }
}
