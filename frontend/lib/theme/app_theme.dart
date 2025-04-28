import 'package:flutter/material.dart';

// Custom dark color scheme for futuristic UI
final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: const Color(0xFF4ECDC4), // Bright teal for primary actions
  onPrimary: Colors.black,
  secondary: const Color(0xFF8555FD), // Purple for secondary actions
  onSecondary: Colors.white,
  error: const Color(0xFFFF6B6B),
  onError: Colors.white,
  background: const Color(0xFF0A0E21), // Deep blue background
  onBackground: Colors.white,
  surface: const Color(0xFF1D1E33), // Slightly lighter blue for cards
  onSurface: Colors.white,
  tertiary: const Color(0xFFFF9F1C), // Orange for warnings/highlights
  onTertiary: Colors.black,
);

// Light color scheme (though the app primarily uses dark theme)
final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF00BFA5),
  onPrimary: Colors.white,
  secondary: const Color(0xFF7C4DFF),
  onSecondary: Colors.white,
  error: const Color(0xFFFF5252),
  onError: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  tertiary: const Color(0xFFFF9800),
  onTertiary: Colors.black,
);

// Text styles for different UI elements
class AppTextStyles {
  static const TextStyle chartLabel = TextStyle(
    color: Colors.white70,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle dataValue = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle alertMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

// Box decoration styles for cards and containers
class AppDecorations {
  static BoxDecoration glassCard = BoxDecoration(
    color: const Color(0xFF1D1E33).withOpacity(0.7),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
  );

  static BoxDecoration gradientCard = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2C2F45), Color(0xFF1A1C2C)],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
