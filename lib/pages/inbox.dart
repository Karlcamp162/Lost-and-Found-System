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
    // Flatten the liked posts to one item per user like
    final notifications = <Map<String, dynamic>>[];

    for (var post in widget.likedPosts) {
      final likedBy = post['likedBy'];
      if (likedBy is List && likedBy.isNotEmpty) {
        for (var user in likedBy) {
          notifications.add({
            'user': user,
            'caption': post['caption'],
            'postId': post['id'],
          });
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child:
              notifications.isEmpty
                  ? const Center(child: Text("No notifications"))
                  : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      final user = notif['user'].toString();
                      final caption = notif['caption'] ?? '';
                      final postId = notif['postId'];

                      final truncated =
                          caption.length > 100
                              ? caption.substring(0, 100) + "..."
                              : caption;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
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
                          child: ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "$user liked your post",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      width: 210,
                                      child: Text(
                                        caption,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    if (caption.length > 10)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.onSeeMore(postId);
                                          },
                                          child: const Text(
                                            "See more",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
