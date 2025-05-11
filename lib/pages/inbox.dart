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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child:
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
                        child: SizedBox(
                          height: 97,
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
                                      title: Text(
                                        "$user liked your post",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            caption,
                                            maxLines: 2, // <<< LIMIT TO 2 LINES
                                            overflow:
                                                TextOverflow
                                                    .ellipsis, // <<< SHOW "..."
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),

                                          if (caption.length > 100)
                                            GestureDetector(
                                              onTap: () {
                                                widget.onSeeMore(post['id']);
                                              },
                                              child: const Text(
                                                "See more",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 2,
                                          ),
                                      visualDensity: VisualDensity.compact,
                                    );
                                  }).toList(),
                            ),
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
