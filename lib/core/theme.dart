import 'package:flutter/material.dart';

/// One place for colour and shape, so every demo screen looks like the same
/// product on a projector: high contrast, large hit targets, no gradients.
///
/// The hit targets are not only an accessibility habit here. `tap` resolves a
/// key or a string to an element and taps the centre of its bounds, so a
/// 54-pixel button is a button that gets hit on the first try in front of an
/// audience — and a 28-pixel one is a demo that misses.
abstract final class DemoTheme {
  static const seed = Color(0xFF4285F4);
  static const ink = Color(0xFF1F1F1F);
  static const muted = Color(0xFF5F6368);
  static const surface = Color(0xFFF6F8FC);
  static const positive = Color(0xFF1E8E3E);
  static const negative = Color(0xFFD93025);

  static ThemeData get light {
    // `primary` is pinned rather than left to the tonal palette: the deck and
    // the app should be the same blue on the projector.
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      primary: seed,
      onPrimary: Colors.white,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: seed, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: negative, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: negative, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // Full-width and tall: see the class doc on why bounds matter.
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
