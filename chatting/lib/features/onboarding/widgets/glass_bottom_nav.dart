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

  static const List<_NavConfig> _tabs = [
    _NavConfig(id: 'home', label: 'Home', icon: Icons.home_rounded),
    _NavConfig(id: 'chats', label: 'Chats', icon: Icons.chat_bubble_rounded),
    _NavConfig(id: 'rooms', label: 'Rooms', icon: Icons.groups_rounded),
    _NavConfig(id: 'profile', label: 'Profile', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.colorsOf(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeIndex = _tabs.indexWhere((tab) => tab.id == activeTab);
    final resolvedIndex = activeIndex == -1 ? 0 : activeIndex;

    return SizedBox(
      height: 98,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = constraints.maxWidth / _tabs.length;
          final fabLeft = (slotWidth * resolvedIndex) + (slotWidth - 56) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 78,
                        padding: const EdgeInsets.only(top: 12, bottom: 10),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.58),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.16)
                                  : Colors.white.withValues(alpha: 0.76),
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.black.withValues(alpha: 0.20)
                                  : const Color(0x160F172A),
                              blurRadius: 28,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: _tabs.map((tab) {
                            final isActive = tab.id == activeTab;
                            return Expanded(
                              child: IconButton(
                                onPressed: () => onChanged(tab.id),
                                tooltip: tab.label,
                                icon: Icon(
                                  tab.icon,
                                  color: isActive
                                      ? Colors.transparent
                                      : palette.textMuted,
                                  size: 24,
                                ),
                              ),
                            );
                          }).toList(growable: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: fabLeft,
                bottom: 30,
                child: _ActiveNavButton(
                  icon: _tabs[resolvedIndex].icon,
                  palette: palette,
                  isDarkMode: isDarkMode,
                  onTap: () => onChanged(_tabs[resolvedIndex].id),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActiveNavButton extends StatelessWidget {
  const _ActiveNavButton({
    required this.icon,
    required this.palette,
    required this.isDarkMode,
    required this.onTap,
  });

  final IconData icon;
  final AppPalette palette;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.indigo, AppTheme.violet],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.indigo.withValues(alpha: 0.38),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

class _NavConfig {
  const _NavConfig({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}
