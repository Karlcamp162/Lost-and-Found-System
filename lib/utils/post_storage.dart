import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PostStorage {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/posts.json';
  }

  static Future<void> savePosts(List<Map<String, dynamic>> posts) async {
    final List<Map<String, dynamic>> postsToSave =
        posts.map((post) {
          final newPost = Map<String, dynamic>.from(post);
          if (newPost['timestamp'] is DateTime) {
            newPost['timestamp'] =
                (newPost['timestamp'] as DateTime).toIso8601String();
          }
          return newPost;
        }).toList();

    final path = await _getFilePath();
    final file = File(path);
    await file.writeAsString(json.encode(postsToSave));
  }

  static Future<List<Map<String, dynamic>>> loadPosts() async {
    final path = await _getFilePath();
    final file = File(path);

    if (await file.exists()) {
      final contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } else {
      return [];
    }
  }
}
