import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:user/theme/controller.dart';
import 'package:user/widgets/list_tile.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late String selectedTheme;
  late bool systemDefault;

  @override
  void initState() {
    super.initState();
    final bool isDark = ThemeController().isDarkModeEnabled();
    systemDefault = ThemeController().getSystemDefault() == isDark;

    if (isDark) {
      selectedTheme = 'dark';
    } else {
      selectedTheme = 'light';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema'),
        centerTitle: true,
      ),
      body: Padding(
        padding: context.mediumPadding,
        child: Column(
          children: [
            ...ListTile.divideTiles(
              color: context.theme.colorScheme.onSurface,
              tiles: [
                EpiListTile(
                  title: 'Sistem',
                  leadingIcon: Icons.settings,
                  customTrailing: systemDefault ? Icon(Icons.check, color: context.theme.colorScheme.primary) : const Center(),
                  onTap: () async {
                    setState(() {
                      systemDefault = true;
                      selectedTheme = 'none';
                    });
                    await ThemeController().updateTheme(value: ThemeController().getSystemDefault());
                  },
                ),
                EpiListTile(
                  title: 'Açık',
                  leadingIcon: Icons.sunny,
                  leadingColor: Colors.redAccent,
                  customTrailing: selectedTheme == 'light' && !systemDefault
                      ? Icon(
                          Icons.check,
                          color: context.theme.colorScheme.primary,
                        )
                      : const Center(),
                  onTap: () async {
                    setState(() {
                      selectedTheme = 'light';
                      systemDefault = false;
                    });
                    await ThemeController().updateTheme(value: false);
                  },
                ),
                EpiListTile(
                  title: 'Koyu',
                  leadingIcon: Icons.nightlight_round,
                  leadingColor: Colors.deepPurple,
                  customTrailing: selectedTheme == 'dark' && !systemDefault
                      ? Icon(
                          Icons.check,
                          color: context.theme.colorScheme.primary,
                        )
                      : const Center(),
                  onTap: () async {
                    setState(() {
                      selectedTheme = 'dark';
                      systemDefault = false;
                    });
                    await ThemeController().updateTheme(value: true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
