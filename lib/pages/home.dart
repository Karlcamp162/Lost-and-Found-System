import 'package:flutter/material.dart';
import 'package:lost_and_found_system/profileNavigations/mypost.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.design_services),
              title: Text("My Post"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPost()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(child: Column()),
    );
  }
}
