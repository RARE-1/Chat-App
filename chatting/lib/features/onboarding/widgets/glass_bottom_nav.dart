import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.colorsOf(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.10)
                      : Colors.white.withValues(alpha: 0.65),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavButton(
                    icon: Icons.home_rounded,
                    isActive: activeTab == 'home',
                    activeColor: AppTheme.indigo,
                    inactiveColor: palette.textMuted,
                    onTap: () => onChanged('home'),
                  ),
                  _NavButton(
                    icon: Icons.chat_bubble_rounded,
                    isActive: activeTab == 'chats',
                    activeColor: AppTheme.indigo,
                    inactiveColor: palette.textMuted,
                    onTap: () => onChanged('chats'),
                  ),
                  _NavButton(
                    icon: Icons.groups_rounded,
                    isActive: activeTab == 'rooms',
                    activeColor: AppTheme.indigo,
                    inactiveColor: palette.textMuted,
                    onTap: () => onChanged('rooms'),
                  ),
                  _NavButton(
                    icon: Icons.person_rounded,
                    isActive: activeTab == 'profile',
                    activeColor: AppTheme.indigo,
                    inactiveColor: palette.textMuted,
                    onTap: () => onChanged('profile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: isActive ? activeColor : inactiveColor,
        size: 22,
      ),
    );
  }
}
