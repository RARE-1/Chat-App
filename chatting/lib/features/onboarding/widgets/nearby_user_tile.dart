import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/nearby_user.dart';

class NearbyUserTile extends StatelessWidget {
  const NearbyUserTile({
    super.key,
    required this.user,
    required this.onFollow,
  });

  final NearbyUser user;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.colorsOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              user.name,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: user.isFollowing
                  ? null
                  : const LinearGradient(
                      colors: [AppTheme.indigo, AppTheme.violet],
                    ),
              color: user.isFollowing ? palette.shellBackground : null,
              borderRadius: BorderRadius.circular(999),
            ),
            child: TextButton(
              onPressed: onFollow,
              child: Text(
                user.isFollowing ? 'Following' : 'Follow',
                style: TextStyle(
                  color: user.isFollowing ? palette.textPrimary : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
