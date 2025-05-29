import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserStorage {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/users.json';
  }

  static Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    final path = await _getFilePath();
    final file = File(path);
    await file.writeAsString(jsonEncode(users));
    print('Saving users to: ${file.path}');
  }

  static Future<List<Map<String, dynamic>>> loadUsers() async {
    final path = await _getFilePath();
    final file = File(path);

    if (await file.exists()) {
      final contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> findUser(String studentId, String password) async {
    final users = await loadUsers();
    try {
      return users.firstWhere(
        (user) => user['studentId'] == studentId && user['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addUser(Map<String, dynamic> newUser) async {
    final users = await loadUsers();
    
    // Check if user with same studentId already exists
    if (users.any((user) => user['studentId'] == newUser['studentId'])) {
      return false;
    }
    
    users.add(newUser);
    await saveUsers(users);
    return true;
  }
} 