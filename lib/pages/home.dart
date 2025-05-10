import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';
import 'package:lost_and_found_system/profileNavigations/aboutUs.dart';
import 'package:lost_and_found_system/profileNavigations/mypost.dart';
import 'package:lost_and_found_system/profileNavigations/settings.dart';

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
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the drawer icon color
        ),
      ),
      endDrawer: Drawer(
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
            ListTile(
              leading: Icon(Icons.design_services),
              title: Text("About Us"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.design_services),
              title: Text("Setting"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.design_services),
              title: Text("Log out"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
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
