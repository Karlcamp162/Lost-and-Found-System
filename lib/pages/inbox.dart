import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  final List<Map<String, dynamic>> likedPosts;
  final Function(String postId) onSeeMore;

  const Inbox({super.key, required this.likedPosts, required this.onSeeMore});

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

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 224, 100, 0.581),
                        border: Border.all(
                          color: Colors.indigo.withOpacity(0.4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children:
                            likedBy.map<Widget>((user) {
                              final truncated =
                                  caption.length > 100
                                      ? caption.substring(0, 100) + "..."
                                      : caption;
                              return ListTile(
                                leading: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                title: Text("$user liked your post"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(truncated),
                                    if (caption.length > 100)
                                      GestureDetector(
                                        onTap: () {
                                          widget.onSeeMore(post['id']);
                                        },
                                        child: const Text(
                                          "See more",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
