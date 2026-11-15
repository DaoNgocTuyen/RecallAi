import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class RecallColors {
  static const primary = Color(0xFF00D6A0);
  static const primaryDark = Color(0xFF00B889);
  static const green = Color(0xFF087F69);
  static const mint = Color(0xFFDDF8F0);
  static const cyan = Color(0xFFD9F8FA);
  static const background = Color(0xFFF7FFFC);
  static const ink = Color(0xFF17332D);
  static const muted = Color(0xFF526D63);
  static const border = Color(0xFFDDECE7);
  static const error = Color(0xFFE05252);
  static const warning = Color(0xFFF3B34C);
}

ThemeData recallTheme() {
  const text = RecallColors.ink;
  final base = ThemeData(useMaterial3: true, fontFamily: 'Inter');
  return base.copyWith(
    scaffoldBackgroundColor: RecallColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: RecallColors.green).copyWith(
      primary: RecallColors.green,
      secondary: RecallColors.primary,
      surface: Colors.white,
      onSurface: text,
      error: RecallColors.error,
    ),
    textTheme: base.textTheme
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 32,
            height: 1.25,
            fontWeight: FontWeight.w700,
            color: text,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24,
            height: 1.33,
            fontWeight: FontWeight.w600,
            color: text,
          ),
          titleLarge: const TextStyle(
            fontSize: 20,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: text,
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
            height: 1.44,
            fontWeight: FontWeight.w600,
            color: text,
          ),
          bodyLarge: const TextStyle(fontSize: 16, height: 1.5, color: text),
          bodyMedium: const TextStyle(fontSize: 14, height: 1.57, color: text),
          bodySmall: const TextStyle(
            fontSize: 12,
            height: 1.5,
            color: RecallColors.muted,
          ),
          labelLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: text,
          ),
        )
        .apply(fontFamily: 'Inter'),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      hintStyle: const TextStyle(color: RecallColors.muted, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: RecallColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: RecallColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: RecallColors.green, width: 1.5),
      ),
    ),
    dividerColor: RecallColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: text,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: RecallColors.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? RecallColors.green
            : Colors.white,
      ),
    ),
  );
}

abstract final class DesignAssets {
  static Map<String, dynamic> _screens = {};
  static Future<void> load() async {
    _screens =
        jsonDecode(await rootBundle.loadString('assets/design_assets.json'))
            as Map<String, dynamic>;
  }

  static String? find(String screen, String symbol) {
    final entry = _screens[screen] as Map<String, dynamic>?;
    final assets = entry?['assets'] as Map<String, dynamic>?;
    final path = assets?[symbol] as String?;
    return path?.replaceFirst('/assets/', 'assets/');
  }
}

class FigmaImage extends StatelessWidget {
  const FigmaImage(
    this.symbol, {
    super.key,
    this.screen = 'S01',
    this.width = 20,
    this.height,
    this.fit = BoxFit.contain,
  });
  final String symbol, screen;
  final double width;
  final double? height;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    final path = DesignAssets.find(screen, symbol);
    if (path == null) return SizedBox(width: width, height: height ?? width);
    return SizedBox(
      width: width,
      height: height ?? width,
      child: path.endsWith('.svg')
          ? SvgPicture.asset(path, fit: fit)
          : Image.asset(path, fit: fit, semanticLabel: 'Linh vật RecallAI'),
    );
  }
}

class RecallRobot extends StatelessWidget {
  const RecallRobot({super.key, this.size = 96, this.authScreen});
  final double size;
  final String? authScreen;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * .08),
    child: FigmaImage(
      authScreen == null ? 'imgRobotRecallAi3DNnBcHa' : 'imgRecallAiCompagnon',
      screen: authScreen ?? 'S01',
      width: size,
      height: size,
    ),
  );
}
