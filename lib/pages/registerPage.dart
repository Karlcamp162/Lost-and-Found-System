import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// ==========================
// User Model
// ==========================
class User {
  final String name;
  final String studentId;
  final String department;
  final String course;
  final String password;

  User({
    required this.name,
    required this.studentId,
    required this.department,
    required this.course,
    required this.password,
  });
}

// ==========================
// Global User Service (Singleton)
// ==========================
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final List<User> users = [];
}

// ==========================
// Register Page State
// ==========================
class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final studentIdController = TextEditingController();
  final departmentController = TextEditingController();
  final courseController = TextEditingController();
  final passwordController = TextEditingController();

  void registerUser() {
    final user = User(
      name: nameController.text,
      studentId: studentIdController.text,
      department: departmentController.text,
      course: courseController.text,
      password: passwordController.text,
    );

    UserService().users.add(user); // Add to global list

    // Clear fields
    nameController.clear();
    studentIdController.clear();
    departmentController.clear();
    courseController.clear();
    passwordController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User registered successfully!')),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    studentIdController.dispose();
    departmentController.dispose();
    courseController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        title: const Text(
          "Register",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: const Center(
          child: Text(
            "NEMSU SmartFind ® 2025",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: studentIdController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Student ID',
                    prefixIcon: const Icon(Icons.add_card),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Department',
                    prefixIcon: const Icon(Icons.school),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: courseController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Course',
                    prefixIcon: const Icon(Icons.book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        registerUser();
                        Navigator.pop(context);
                      },
                      child: const Text("Register"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
