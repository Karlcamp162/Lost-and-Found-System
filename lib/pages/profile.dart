import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';
import 'package:lost_and_found_system/profileNavigations/aboutUs.dart';
import 'package:lost_and_found_system/profileNavigations/contactUs.dart';
import 'package:lost_and_found_system/profileNavigations/privacy.dart';
import 'package:lost_and_found_system/profileNavigations/sendFeedback.dart';

class Profile extends StatefulWidget {
  final String currentUserName;
  final String studentId; // Add a new parameter for studentId
  const Profile({
    super.key,
    required this.currentUserName,
    required this.studentId,
  });

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
        child: SingleChildScrollView(
          // Wrap the entire content with SingleChildScrollView
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
                  icon: Icons.phone_android,
                  title: "About the App",
                  destination: AboutApp(),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.data_usage,
                  title: "Data and Privacy",
                  destination: Privacy(),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.report_gmailerrorred,
                  title: "Contact Us",
                  destination: ContactUs(),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.feedback_outlined,
                  title: "Send Feedback",
                  destination: SendFeedback(),
                ),

                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, size: 20),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      color: const Color.fromRGBO(244, 67, 54, 0.877),
                      fontSize: 15,
                    ),
                  ),
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
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
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
