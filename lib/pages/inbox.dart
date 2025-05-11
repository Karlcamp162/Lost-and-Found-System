import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  final List<Map<String, dynamic>> likedPosts;

  const Inbox({super.key, required this.likedPosts});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    // Filter posts that have at least one like
    final likedPosts =
        widget.likedPosts.where((post) {
          final likedBy = post['likedBy'];
          return likedBy is List && likedBy.isNotEmpty;
        }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Inbox")),
      body:
          likedPosts.isEmpty
              ? const Center(child: Text("No notifications"))
              : ListView.builder(
                itemCount: likedPosts.length,
                itemBuilder: (context, index) {
                  final post = likedPosts[index];
                  final caption = post['caption'] ?? '';
                  final likedBy =
                      (post['likedBy'] as List<dynamic>)
                          .map((e) => e.toString())
                          .toList();

                  return Column(
                    children:
                        likedBy.map<Widget>((user) {
                          return ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            title: Text("$user liked your post"),
                            subtitle: Text(caption),
                          );
                        }).toList(),
                  );
                },
              ),
    );
  }
}
