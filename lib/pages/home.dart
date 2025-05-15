import 'dart:io' show File;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found_system/components/bottom_navigation_widget.dart';
import 'package:lost_and_found_system/pages/inbox.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';
import 'package:lost_and_found_system/pages/preference.dart';
import 'package:lost_and_found_system/pages/profile.dart';
import 'package:lost_and_found_system/profileNavigations/aboutUs.dart';
import 'package:lost_and_found_system/profileNavigations/contactUs.dart';
import 'package:lost_and_found_system/profileNavigations/privacy.dart';
import 'package:lost_and_found_system/profileNavigations/sendFeedback.dart';
import 'package:lost_and_found_system/utils/post_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final String currentUserName;
  final String currentStudentId;
  final String studentDepartmentName;
  final String studentCourseName; // Added this line to pass studentId

  const Home({
    super.key,
    required this.currentUserName,
    required this.currentStudentId,
    required this.studentDepartmentName,
    required this.studentCourseName,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> posts = [];

  int _selectedIndex = 0;
  String get currentUser => widget.currentUserName;
  String get currentStudent => widget.currentStudentId; // Access studentId
  String get studentDepartment => widget.studentDepartmentName;
  String get studentCourse => widget.studentCourseName;

  final ScrollController _scrollController = ScrollController();
  String? selectedPostId;
  String _title = "";

  @override
  void initState() {
    super.initState();
    _loadPosts(); // <-- Load saved posts
  }

  void _loadPosts() async {
    final loadedPosts = await PostStorage.loadPosts();
    setState(() {
      posts.addAll(
        loadedPosts.map((post) {
          post['timestamp'] = DateTime.parse(post['timestamp']);
          return post;
        }),
      );
    });
  }

  void tabIndex(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = "Home";
          break;
        case 1:
          _title = "Notifications";
          break;
        case 2:
          _title = "Preference";
          break;
        case 3:
          _title = "Profile";
          break;
      }
    });
  }

  void _addPost(String post, List<String> imagePaths, DateTime timestamp) {
    final newPost = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'caption': post,
      'images': imagePaths,
      'timestamp': timestamp.toIso8601String(), // Save as string
      'likes': 0,
      'isLiked': false,
      'likedBy': <String>[],
      'authorName': currentUser,
      'authorId': currentStudent,
    };

    setState(() {
      posts.insert(0, newPost);
    });

    PostStorage.savePosts(posts); // Save to file
  }

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

                                  PostStorage.savePosts(posts); // Save changes
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
                              launchUrl(
                                Uri.parse(
                                  'https://www.facebook.com/angel.alaba.13',
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
                                ).withOpacity(0.5),
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
        );
      case 2:
        return Preference();
      case 3:
        return Profile(
          currentUserName: currentUser,
          studentId: currentStudent,
          studentDepartmentName: studentDepartment,
          studentCourseName: studentCourse,
        );

      default:
        return _buildHomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: TextStyle(color: Colors.white)),
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
            UserAccountsDrawerHeader(
              accountName: Text(currentUser),
              accountEmail: Text(currentStudent),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/image.png"),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/cover.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text("About the App"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.data_usage),
              title: Text("Data and Privacy"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Privacy()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report_gmailerrorred),
              title: Text("Contact Us"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined),
              title: Text("Send Feedback"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendFeedback()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log out"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
        child: Icon(Icons.add, size: 35),
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
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 24,
              ),
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
                        SizedBox(width: 9),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              currentStudent,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
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
