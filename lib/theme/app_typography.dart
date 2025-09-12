import 'package:flutter/material.dart';

/// Typography system for consistent text styling across the app
class AppTypography {
  static const String fontFamily = 'SpoqaHanSansNeo';
  
  // Hero/Display text (32px)
  static const TextStyle hero = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  // Main heading (24px)
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
  );
  
  // Section heading (20px)
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Subsection heading (18px)
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Body text (16px)
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  
  // Small body text (15px)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  
  // Caption text (14px)
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  // Label text (12px)
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );
  
  // Helper methods for responsive typography
  static TextStyle getResponsive(
    TextStyle baseStyle,
    bool isTabletLandscape,
  ) {
    if (!isTabletLandscape) return baseStyle;
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 16) * 1.15,
    );
  }
  
  // Apply white color with shadow for glass effect
  static TextStyle withGlassEffect(TextStyle style) {
    return style.copyWith(
      color: Colors.white,
      shadows: const [
        Shadow(
          offset: Offset(0, 1),
          blurRadius: 3.0,
          color: Color(0x26000000),
        ),
      ],
    );
  }
}