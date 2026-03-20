import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class RippleIndicator extends StatefulWidget {
  const RippleIndicator({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  State<RippleIndicator> createState() => _RippleIndicatorState();
}

class _RippleIndicatorState extends State<RippleIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _RipplePainter(
              progress: _controller.value,
              isDarkMode: widget.isDarkMode,
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.indigo, AppTheme.violet],
                  ),
                ),
                child: const Text(
                  'You',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.progress,
    required this.isDarkMode,
  });

  final double progress;
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const rippleCount = 3;

    for (var i = 0; i < rippleCount; i++) {
      final waveProgress = (progress + (i / rippleCount)) % 1.0;
      final scale = 0.6 + waveProgress;
      final opacity = (1 - waveProgress) * 0.6;
      final radius = (size.width * 0.5) * scale;

      final paint = Paint()
        ..color = AppTheme.indigo.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawCircle(center, radius, paint);
    }

    final outerPaint = Paint()
      ..color = isDarkMode ? Colors.white12 : const Color(0x220F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, 96, outerPaint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
