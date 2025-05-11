import 'package:flutter/material.dart';

class Preference extends StatefulWidget {

  const Preference({super.key});

  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final themeNames = AppThemes.themes.keys.toList();

  final themeColors = {
    'Original': const Color.fromRGBO(209, 175, 247, 1),
    'Light': Colors.white,
    'Dark': Colors.grey[850]!,
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: themeNames.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final name = themeNames[index];
            final color = themeColors[name]!;
            return GestureDetector(
              onTap: () {
                ThemeController.setTheme(name);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: (name == 'Light' || name == 'Original')
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppThemes {
  static final themes = {
    'Original': ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(209, 175, 247, 1),
      ),
      useMaterial3: true,
    ),
    'Light': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      useMaterial3: true,
    ),
    'Dark': ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey[900]!,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    'Red': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      useMaterial3: true,
    ),
    'Green': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    'Blue': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
  };
}

class ThemeController {
  static final ValueNotifier<ThemeData> currentTheme =
  ValueNotifier(AppThemes.themes['Original']!);

  static void setTheme(String name) {
    currentTheme.value = AppThemes.themes[name]!;
  }
}
