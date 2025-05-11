import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';
import 'package:lost_and_found_system/profileNavigations/aboutUs.dart';
import 'package:lost_and_found_system/profileNavigations/mypost.dart';
import 'package:lost_and_found_system/profileNavigations/settings.dart';

class Profile extends StatefulWidget {
  final String currentUserName;
  final String studentId; // Add a new parameter for studentId
  const Profile({super.key, required this.currentUserName, required this.studentId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String get currentUser => widget.currentUserName;
  String get studentId => widget.studentId; // Access the studentId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/image.png'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                currentUser,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                studentId, // Display studentId here
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildMenuTile(
                context,
                icon: Icons.dashboard,
                title: "My Post",
                destination: MyPost(),
              ),
              _buildMenuTile(
                context,
                icon: Icons.settings,
                title: "Settings",
                destination: Settings(),
              ),
              _buildMenuTile(
                context,
                icon: Icons.info_outline,
                title: "About Us",
                destination: AboutUs(),
              ),
              const Spacer(),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Log Out", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context,
      {required IconData icon,
        required String title,
        required Widget destination}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
