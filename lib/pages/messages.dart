import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final List<Map<String, String>> messageThreads = [
    {
      'name': 'Alex Smith',
      'lastMessage': 'Thanks for the info!',
      'time': '2:30 PM',
      'avatar': 'assets/images/image.png',
    },
    {
      'name': 'Jamie Lin',
      'lastMessage': 'Is this your bag?',
      'time': '1:15 PM',
      'avatar': 'assets/images/image.png',
    },
    {
      'name': 'Taylor Gomez',
      'lastMessage': 'Found it!',
      'time': '11:00 AM',
      'avatar': 'assets/images/image.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: messageThreads.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final thread = messageThreads[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(thread['avatar']!),
              radius: 25,
            ),
            title: Text(
              thread['name']!,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(thread['lastMessage']!),
            trailing: Text(
              thread['time']!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Open chat with ${thread['name']}")),
              );
              // Here you can push to a ChatDetail page
            },
          );
        },
      ),
    );
  }
}
