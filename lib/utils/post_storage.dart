import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PostStorage {
  static Future<String> _getFilePath() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Safe internal location
    return '${directory.path}/posts.json';
  }

  static Future<void> savePosts(List<Map<String, dynamic>> posts) async {
    final path = await _getFilePath();
    final file = File(path);
    await file.writeAsString(jsonEncode(posts));
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
