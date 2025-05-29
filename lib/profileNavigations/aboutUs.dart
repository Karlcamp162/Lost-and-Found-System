import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'About the App',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              'Welcome to the Official NEMSU SmartFind App',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 249, 211, 1),
                border: Border.all(
                  color: const Color.fromRGBO(194, 154, 10, 1).withOpacity(0.4),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This mobile application is proudly developed for and owned by North Eastern Mindanao State University (NEMSU).",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "It is designed to help students foster a stronger campus community by promoting honesty and accountability. The app allows users to post items they’ve found within the campus that may have been lost by others. Likewise, students who have misplaced their belongings can browse posts in real-time and reach out to the person who found their item through the app’s built-in communication features.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Whether it's a lost ID, umbrella, or any personal belonging, this platform bridges the gap between finders and owners—making it easier to return items to their rightful owners.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 60),

                  Text(
                    "About the Developers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "This application was developed by two dedicated and passionate 3rd year Computer Science students, Angel Kyle L. Alaba and Karl Louise M. Campos from North Eastern Mindanao State University as part of their final requirement in Mobile Computing I. ",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "With a commitment to innovation and solving real-world problems through technology, the developers aimed to create a user-friendly, practical, and secure mobile solution that addresses a common issue among students.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
