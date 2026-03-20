import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/views/onboarding_flow_view.dart';

class ChattingApp extends StatelessWidget {
  const ChattingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const OnboardingFlowView(),
    );
  }
}
