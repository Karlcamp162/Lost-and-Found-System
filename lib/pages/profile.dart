import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';
import 'package:lost_and_found_system/profileNavigations/aboutUs.dart';
import 'package:lost_and_found_system/profileNavigations/contactUs.dart';
import 'package:lost_and_found_system/profileNavigations/privacy.dart';
import 'package:lost_and_found_system/profileNavigations/sendFeedback.dart';

class Profile extends StatefulWidget {
  final String currentUserName;
  final String studentId; // Add a new parameter for studentId
  final String studentDepartmentName;
  final String studentCourseName; // Example department
  const Profile({
    super.key,
    required this.currentUserName,
    required this.studentId,
    required this.studentDepartmentName,
    required this.studentCourseName,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String get currentUser => widget.currentUserName;
  String get studentId => widget.studentId;
  String get studentDepartment => widget.studentDepartmentName;
  String get studentCourse => widget.studentCourseName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the entire content with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/image.png'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUser,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        studentId,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(thickness: 1, color: Colors.black12),
                      SizedBox(height: 10),
                      const Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(114, 114, 114, 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.apartment,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Department: $studentDepartment",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.school,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Course: $studentCourse",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(thickness: 1, color: Colors.black12),
                SizedBox(height: 20),
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
                const Divider(thickness: 1, color: Colors.black12),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 20,
                  ),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Color.fromRGBO(244, 67, 54, 0.877),
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    // Show logout confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Log Out'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: Text('Log Out', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
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
