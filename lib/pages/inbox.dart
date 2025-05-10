import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  final List<Map<String, dynamic>> likedPosts;

  const Inbox({super.key, required this.likedPosts});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Filter posts that have at least one like (likedBy is a List<String>)
    final likedPosts =
        widget.likedPosts
            .where(
              (post) =>
                  post['likedBy'] != null &&
                  (post['likedBy'] as List).isNotEmpty,
            )
            .toList();

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
                  // Ensure likedBy is safely cast to List<String>
                  final likedBy = (post['likedBy'] ?? []).cast<String>();

                  // Directly mapping likedBy to a List<Widget>
                  List<Widget> likeNotifications =
                      likedBy.map((user) {
                        return ListTile(
                          leading: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          title: Text("$user liked your post"),
                          subtitle: Text(caption),
                        );
                      }).toList();

                  return Column(
                    children: likeNotifications, // Assign the List<Widget> here
                  );
                },
              ),
    );
  }
}
