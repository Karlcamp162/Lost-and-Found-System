import 'package:flutter/material.dart';

class Preference extends StatefulWidget {
  const Preference({super.key});

  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final themeNames = AppThemes.themes.keys.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: themeNames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final name = themeNames[index];
            final theme = AppThemes.themes[name]!;
            final scheme = theme.colorScheme;

            return GestureDetector(
              onTap: () {
                ThemeController.setTheme(name);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black12, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15),
                              ),
                              color: scheme.primary,
                            ),
                          ),
                        ),
                        Expanded(child: Container(color: scheme.secondary)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(15),
                              ),
                              color: scheme.inversePrimary ?? scheme.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          const Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    'Classic Light': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      useMaterial3: true,
    ),
    'Midnight': ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey[900]!,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    'Cherry': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      useMaterial3: true,
    ),
    'Forest': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    'Ocean': ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
  };
}

class ThemeController {
  static final ValueNotifier<ThemeData> currentTheme = ValueNotifier(
    AppThemes.themes['Original']!,
  );

  static void setTheme(String name) {
    currentTheme.value = AppThemes.themes[name]!;
  }
}
