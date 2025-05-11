import 'dart:io' show File;
import 'package:intl/intl.dart';

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
  final String currentUserName;
  const Home({super.key, required this.currentUserName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> posts = [];
  int _selectedIndex = 0;
  String get currentUser => widget.currentUserName;
  final ScrollController _scrollController = ScrollController();
  String? selectedPostId;

  void tabIndex(int index) {
    setState(() {
      _selectedIndex = index;
      print("Selected index: $_selectedIndex");
    });
  }

  void _addPost(String post, List<String> imagePaths, DateTime timestamp) {
    setState(() {
      posts.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'caption': post,
        'images': imagePaths,
        'timestamp': timestamp,
        'likes': 0,
        'isLiked': false,
        'likedBy': <String>[],
      });
    });
  }

  late final List<Widget> _currentTab;

  Widget _buildHomeTab() {
    return SafeArea(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final DateTime timestamp = post['timestamp'];
          final String formattedTime = DateFormat('hh:mm a').format(timestamp);

          return Column(
            children: [
              Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 29,
                            backgroundImage: AssetImage(
                              "assets/images/image.png",
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                formattedTime,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.indigo.withOpacity(0.2),
                            width: 1.0,
                          ), // Set border color and width
                          borderRadius: BorderRadius.circular(
                            2.0,
                          ), // Optional: Set border radius
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['caption'],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            if (post['images'] != null)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    (post['images'] as List<String>).map((
                                      path,
                                    ) {
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
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    post['isLiked'] = !post['isLiked'];
                                    post['likes'] += post['isLiked'] ? 1 : -1;

                                    // Simulated current user name

                                    if (post['likedBy'] == null ||
                                        post['likedBy'] is! List) {
                                      post['likedBy'] = <String>[];
                                    }

                                    final likedBy =
                                        post['likedBy'] as List<String>;

                                    if (post['isLiked']) {
                                      if (!likedBy.contains(currentUser)) {
                                        likedBy.add(currentUser);
                                      }
                                    } else {
                                      likedBy.remove(currentUser);
                                    }
                                  });
                                },

                                icon: Icon(
                                  post['isLiked']
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color:
                                    post['isLiked'] ? Colors.red : Colors.grey,
                              ),
                              Text("${post['likes']}"),
                            ],
                          ),

                          SizedBox(width: 147),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Messages(),
                                ),
                              );
                            },
                            label: Text("Message"),
                            icon: Icon(Icons.message),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                208,
                                213,
                                241,
                                1,
                              ),
                              foregroundColor: Colors.black,
                              // elevation: 2,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              side: BorderSide(
                                color: const Color.fromRGBO(
                                  208,
                                  208,
                                  208,
                                  1,
                                ).withOpacity(0.5), // Subtle border color
                                width: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget _getTab(int index) {
    switch (index) {
      case 0:
        return _buildHomeTab();
      case 1:
        return Inbox(
          likedPosts: posts,
          onSeeMore: (postId) {
            setState(() {
              selectedPostId = postId;
              _selectedIndex = 0; // switch to Home tab
            });

            // Wait for frame render then scroll
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final index = posts.indexWhere((p) => p['id'] == postId);
              if (index != -1) {
                _scrollController.animateTo(
                  index * 280.0, // estimated height per post
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            });
          },
        ); // This ensures it always gets updated posts
      case 2:
        return const Messages();
      case 3:
        return const Profile();
      default:
        return _buildHomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> _currentTab = [
    //   _buildHomeTab(),
    //   Inbox(likedPosts: posts),
    //   const Messages(),
    //   const Profile(),
    // ];

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

      body: _getTab(_selectedIndex),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }

  void _showAddPostDialog(BuildContext context) {
    final TextEditingController postController = TextEditingController();
    List<String> selectedImages = [];
    final String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

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
                          backgroundImage: AssetImage(
                            "assets/images/image.png",
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          currentUser,
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
                      final DateTime now = DateTime.now();
                      _addPost(postController.text, selectedImages, now);
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
