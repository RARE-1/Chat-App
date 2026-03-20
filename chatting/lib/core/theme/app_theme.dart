import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color indigo = Color(0xFF6366F1);
  static const Color violet = Color(0xFF9333EA);

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        palette: const AppPalette(
          appBackground: Color(0xFF020617),
          shellBackground: Color(0xFF0B0F1A),
          surfaceSoft: Color(0x14FFFFFF),
          stroke: Color(0x1AFFFFFF),
          textPrimary: Colors.white,
          textMuted: Color(0xFF94A3B8),
          shellGradient: [
            Color(0xFF0F172A),
            Color(0xFF020617),
            Colors.black,
          ],
        ),
      );

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        palette: const AppPalette(
          appBackground: Color(0xFFF4F7FB),
          shellBackground: Color(0xFFFDFEFF),
          surfaceSoft: Color(0xFFF1F5F9),
          stroke: Color(0x140F172A),
          textPrimary: Color(0xFF0F172A),
          textMuted: Color(0xFF64748B),
          shellGradient: [
            Color(0xFFE0EAFF),
            Color(0xFFF6F8FF),
            Color(0xFFFFFFFF),
          ],
        ),
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppPalette palette,
  }) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: indigo,
      brightness: brightness,
    ).copyWith(
      surface: palette.shellBackground,
      primary: indigo,
      secondary: violet,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.appBackground,
      extensions: [palette],
      iconTheme: IconThemeData(color: palette.textPrimary),
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
            bodyColor: palette.textPrimary,
            displayColor: palette.textPrimary,
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: indigo),
        ),
        hintStyle: TextStyle(color: palette.textMuted),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.stroke),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? palette.textMuted : indigo,
        ),
      ),
    );
  }

  static AppPalette colorsOf(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>();
    assert(palette != null, 'AppPalette is missing from the current theme.');
    return palette!;
  }
}

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.appBackground,
    required this.shellBackground,
    required this.surfaceSoft,
    required this.stroke,
    required this.textPrimary,
    required this.textMuted,
    required this.shellGradient,
  });

  final Color appBackground;
  final Color shellBackground;
  final Color surfaceSoft;
  final Color stroke;
  final Color textPrimary;
  final Color textMuted;
  final List<Color> shellGradient;

  @override
  AppPalette copyWith({
    Color? appBackground,
    Color? shellBackground,
    Color? surfaceSoft,
    Color? stroke,
    Color? textPrimary,
    Color? textMuted,
    List<Color>? shellGradient,
  }) {
    return AppPalette(
      appBackground: appBackground ?? this.appBackground,
      shellBackground: shellBackground ?? this.shellBackground,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      stroke: stroke ?? this.stroke,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      shellGradient: shellGradient ?? this.shellGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      appBackground: Color.lerp(appBackground, other.appBackground, t)!,
      shellBackground: Color.lerp(shellBackground, other.shellBackground, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      shellGradient: List<Color>.generate(
        shellGradient.length,
        (index) => Color.lerp(
          shellGradient[index],
          other.shellGradient[index],
          t,
        )!,
      ),
    );
  }
}
