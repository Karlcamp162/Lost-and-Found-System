import 'package:flutter/material.dart';
import 'package:lost_and_found_system/pages/preference.dart';
import 'package:lost_and_found_system/pages/loginPage.dart';

void main() {
  runApp(const LostAndFoundSystem());
}

class LostAndFoundSystem extends StatelessWidget {
  const LostAndFoundSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: ThemeController.currentTheme,
      builder: (context, theme, _) {
        return MaterialApp(
          title: "NEMSU SmartFind",
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: LoginPage(),
        );
      },
    );
  }
}
