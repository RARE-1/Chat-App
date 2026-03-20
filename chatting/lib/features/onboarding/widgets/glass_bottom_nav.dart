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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.stroke),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_rounded,
            isActive: activeTab == 'home',
            onTap: () => onChanged('home'),
          ),
          _NavItem(
            label: 'Chats',
            icon: Icons.chat_bubble_rounded,
            isActive: activeTab == 'chats',
            onTap: () => onChanged('chats'),
          ),
          _NavItem(
            label: 'Rooms',
            icon: Icons.groups_rounded,
            isActive: activeTab == 'rooms',
            onTap: () => onChanged('rooms'),
          ),
          _NavItem(
            label: 'Profile',
            icon: Icons.person_rounded,
            isActive: activeTab == 'profile',
            onTap: () => onChanged('profile'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.colorsOf(context);
    final color = isActive ? AppTheme.indigo : palette.textMuted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
