import 'package:flutter/material.dart';

/// Color system for liquid glass design with near-white tones
class AppColors {
  // Primary glass colors (very subtle, near-white)
  static Color glassWhite = Colors.white.withValues(alpha: 0.95);
  static Color glassFrost = Colors.white.withValues(alpha: 0.85);
  static Color glassLight = Colors.white.withValues(alpha: 0.15);
  static Color glassMedium = Colors.white.withValues(alpha: 0.25);
  static Color glassStrong = Colors.white.withValues(alpha: 0.35);
  
  // Subtle accent colors (very light, near-white tints)
  static Color selectedCharacter = const Color(0x1A3B82F6); // Very light blue
  static Color matchedCharacter = const Color(0x1A9333EA); // Very light purple
  static Color commonTraits = const Color(0x1A10B981); // Very light green
  static Color strengths = const Color(0x1AF59E0B); // Very light amber
  static Color growthAreas = const Color(0x1A0EA5E9); // Very light cyan
  
  // Border colors (subtle white borders)
  static Color borderLight = Colors.white.withValues(alpha: 0.2);
  static Color borderMedium = Colors.white.withValues(alpha: 0.3);
  static Color borderStrong = Colors.white.withValues(alpha: 0.4);
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static Color textSecondary = Colors.white.withValues(alpha: 0.9);
  static Color textTertiary = Colors.white.withValues(alpha: 0.8);
  
  // Shadow colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);
  static Color shadowStrong = Colors.black.withValues(alpha: 0.15);
  
  // Glow effects
  static Color glowWhite = Colors.white.withValues(alpha: 0.15);
  static Color glowSoft = Colors.white.withValues(alpha: 0.08);
}