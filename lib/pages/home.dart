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
  final String studentCourseName;

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
  String get currentStudent => widget.currentStudentId;
  String get studentDepartment => widget.studentDepartmentName;
  String get studentCourse => widget.studentCourseName;

  final ScrollController _scrollController = ScrollController();
  String? selectedPostId;
  String _title = "";

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() async {
    final loadedPosts = await PostStorage.loadPosts();
    setState(() {
      posts.clear(); // Clear existing posts before loading
      posts.addAll(
        loadedPosts.map((post) {
          post['timestamp'] = DateTime.parse(post['timestamp']);
          post['images'] = (post['images'] as List<dynamic>).cast<String>();
          post['likedBy'] = (post['likedBy'] as List<dynamic>).cast<String>();
          // Initialize isLiked based on whether current user has liked the post
          post['isLiked'] = (post['likedBy'] as List<String>).contains(
            currentUser,
          );
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
          _title = "SmartFind";
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
      'timestamp': timestamp.toIso8601String(),
      'likes': 0,
      'isLiked': false,
      'likedBy': <String>[],
      'authorName': currentUser,
      'authorId': currentStudent,
      'department': studentDepartment,
      'course': studentCourse,
    };

    setState(() {
      newPost['timestamp'] = timestamp;
      posts.insert(0, newPost);
    });

    final newPostForStorage = Map<String, dynamic>.from(newPost);
    newPostForStorage['timestamp'] = timestamp.toIso8601String();

    PostStorage.savePosts([
      ...posts.map((post) {
        final storagePost = Map<String, dynamic>.from(post);
        storagePost['timestamp'] =
            (post['timestamp'] as DateTime).toIso8601String();
        return storagePost;
      }),
    ]);
  }

  void _updatePost(int index, String caption, List<String> imagePaths) {
    setState(() {
      posts[index]['caption'] = caption;
      posts[index]['images'] = imagePaths;
      posts[index]['editedAt'] = DateTime.now().toIso8601String();
    });

    PostStorage.savePosts([
      ...posts.map((post) {
        final storagePost = Map<String, dynamic>.from(post);
        storagePost['timestamp'] =
            (post['timestamp'] as DateTime).toIso8601String();
        return storagePost;
      }),
    ]);
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
          final bool isCurrentUserPost = post['authorId'] == currentStudent;

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 29,
                                  backgroundImage: AssetImage(
                                    "assets/images/person.jpg",
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post['authorName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        post['authorId'],
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            formattedTime,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (post['editedAt'] != null)
                                            Text(
                                              ' (edited)',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          if (isCurrentUserPost)
                                            Container(
                                              margin: EdgeInsets.only(left: 8),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[100],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'Your Post',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCurrentUserPost)
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                // Show options menu for user's own post
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('Post Options'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              title: Text('Edit Post'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _showEditPostDialog(
                                                  context,
                                                  post,
                                                  index,
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              title: Text('Delete Post'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                // Show confirmation dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                        title: Text(
                                                          'Delete Post?',
                                                        ),
                                                        content: Text(
                                                          'Are you sure you want to delete this post? This action cannot be undone.',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                            child: Text(
                                                              'Cancel',
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                posts.removeAt(
                                                                  index,
                                                                );
                                                              });
                                                              PostStorage.savePosts([
                                                                ...posts.map((
                                                                  post,
                                                                ) {
                                                                  final storagePost =
                                                                      Map<
                                                                        String,
                                                                        dynamic
                                                                      >.from(
                                                                        post,
                                                                      );
                                                                  storagePost['timestamp'] =
                                                                      (post['timestamp']
                                                                              as DateTime)
                                                                          .toIso8601String();
                                                                  return storagePost;
                                                                }),
                                                              ]);
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Post deleted',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                );
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.indigo.withOpacity(0.2),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(2.0),
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
                            if (post['images'] != null &&
                                (post['images'] as List).isNotEmpty)
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                                  PostStorage.savePosts([
                                    ...posts.map((p) {
                                      final storagePost =
                                          Map<String, dynamic>.from(p);
                                      storagePost['timestamp'] =
                                          (p['timestamp'] as DateTime)
                                              .toIso8601String();
                                      return storagePost;
                                    }),
                                  ]);
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
                          if (!isCurrentUserPost)
                            ElevatedButton.icon(
                              onPressed: () {
                                launchUrl(Uri.parse('https://www.facebook.com/michael.estal'),
                                    mode: LaunchMode.externalApplication);
                              },

                              icon: Icon(Icons.message),
                              label: Text("Contact"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  208,
                                  213,
                                  241,
                                  1,
                                ),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
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
              _selectedIndex = 0;
            });

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final index = posts.indexWhere((p) => p['id'] == postId);
              if (index != -1) {
                _scrollController.animateTo(
                  index * 280.0,
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
        iconTheme: const IconThemeData(color: Colors.white),
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
                // Show logout confirmation
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Log Out'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Close both the dialog and drawer before logging out
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Close drawer
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
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

  void _showEditPostDialog(
    BuildContext context,
    Map<String, dynamic> post,
    int index,
  ) {
    final TextEditingController postController = TextEditingController(
      text: post['caption'],
    );
    final List<String> selectedImages = List.from(post['images']);

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
                  selectedImages.clear();
                  selectedImages.addAll(images.map((xfile) => xfile.path));
                });
              } else if (images.length > 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select up to 5 images only."),
                  ),
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
                "Edit Post",
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
                    if (selectedImages.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Images:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                selectedImages.map((path) {
                                  return Stack(
                                    children: [
                                      Image.file(
                                        File(path),
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setDialogState(() {
                                              selectedImages.remove(path);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await pickImages();
                      },
                      icon: Icon(Icons.image),
                      label: Text(
                        selectedImages.isEmpty
                            ? "Add Images (max 5)"
                            : "Change Images (max 5)",
                      ),
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
                      _updatePost(index, postController.text, selectedImages);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post updated successfully'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post caption cannot be empty'),
                        ),
                      );
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
