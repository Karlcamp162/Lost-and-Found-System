import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/home.dart';

void main() {
  runApp(Lost_And_Found_System());
}

class Lost_And_Found_System extends StatefulWidget {
  const Lost_And_Found_System({super.key});

  @override
  State<Lost_And_Found_System> createState() => _Lost_And_Found_SystemState();
}

class _Lost_And_Found_SystemState extends State<Lost_And_Found_System> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lost and Found System",
      debugShowCheckedModeBanner: false,
      home: Home(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(209, 175, 247, 1),
        ),
        useMaterial3: true,
      ),
    );
  }
}
