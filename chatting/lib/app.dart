import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/views/onboarding_flow_view.dart';

class ChattingApp extends StatefulWidget {
  const ChattingApp({super.key});

  @override
  State<ChattingApp> createState() => _ChattingAppState();
}

class _ChattingAppState extends State<ChattingApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: OnboardingFlowView(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
