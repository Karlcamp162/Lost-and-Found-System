import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found_system/components/bottom_navigation_widget.dart';
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
  final List<String> posts = [];

  void _addPost(String post) {
    setState(() {
      posts.add(post);
    });
  }

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
      bottomNavigationBar: BottomNavigationWidget(),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.dashboard_sharp),
              title: Text("My Post"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPost()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.groups_3),
              title: Text("About Us"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
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
      body: SafeArea(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(posts[index]));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    final TextEditingController postController = TextEditingController();
    String? selectedImage;

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          selectedImage = image.path; // Get the image file path
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return SafeArea(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Create Post",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 29,
                        backgroundImage: AssetImage("assets/avatar.png"),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Angel Kyle L. Alaba",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SafeArea(
                    child: TextField(
                      controller: postController,
                      maxLines: 7,
                      decoration: InputDecoration(
                        hintText: "Where did the item last seen?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: pickImage, // Call the image picker
                    icon: const Icon(Icons.image),
                    label: const Text("Add Image"),
                  ),
                  if (selectedImage != null) ...[
                    const SizedBox(height: 10),
                    Image.file(
                      File(selectedImage!), // Display the selected image
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (postController.text.isNotEmpty) {
                    _addPost(postController.text);
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Post"),
              ),
            ],
          ),
        );
      },
    );
  }
}
