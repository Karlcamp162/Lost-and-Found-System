import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found_system/components/bottom_navigation_widget.dart';
import 'package:lost_and_found_system/pages/inbox.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';
import 'package:lost_and_found_system/pages/messages.dart';
import 'package:lost_and_found_system/pages/profile.dart';
import 'package:lost_and_found_system/profileNavigations/aboutUs.dart';
import 'package:lost_and_found_system/profileNavigations/mypost.dart';
import 'package:lost_and_found_system/profileNavigations/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<Map<String, dynamic>> posts = [];

  int _selectedIndex = 0;

  void tabIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  void _addPost(String post, List<String> imagePaths) {
    setState(() {
      posts.add({'caption': post, 'images': imagePaths});
    });
  }
  late final List<Widget> _currentTab;
  @override
  void initState() {
    super.initState();
    _currentTab = [
      _buildHomeTab(),
      const Inbox(),
      const Messages(),
      const Profile(),
    ];
  }
  Widget _buildHomeTab() {
    return SafeArea(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['caption'], style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    if (post['images'] != null)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (post['images'] as List<String>).map((path) {
                              final file = File(path);
                              if (file.existsSync()) {
                                return Image.file(
                                  file,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image),
                                );
                              }
                            }).toList(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the drawer icon color
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        tabIndex: tabIndex,
        colorIndex: _selectedIndex,
      ),
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

      body: IndexedStack(
        index: _selectedIndex,
        children: _currentTab,

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
    List<String> selectedImages = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickImages() async {
              final ImagePicker picker = ImagePicker();
              final List<XFile> images = await picker.pickMultiImage();

              if (images.isNotEmpty && images.length <= 5) {
                setDialogState(() {
                  selectedImages = images.map((xfile) => xfile.path).toList();
                });
              } else if (images.length > 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select up to 5 images only.")),
                );
              }
            }

            return AlertDialog(
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
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: postController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Where did you last see the item?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          selectedImages.map((path) {
                            return Image.file(
                              File(path),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await pickImages();
                      },
                      icon: Icon(Icons.image),
                      label: Text("Select Images (max 5)"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (postController.text.isNotEmpty) {
                      _addPost(postController.text, selectedImages);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Post"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}



