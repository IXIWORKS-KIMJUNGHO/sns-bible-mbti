import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

/// Rectangular liquid glass widget for mobile portrait layouts
///
/// Provides a glassmorphism effect with rounded corners,
/// optimized for vertical scrolling and space efficiency
class RectangularLiquidGlassWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color glassColor;
  final double opacity;
  final double borderOpacity;
  final double blurRadius;

  const RectangularLiquidGlassWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 28.0,
    this.glassColor = Colors.white,
    this.opacity = 0.15,
    this.borderOpacity = 0.3,
    this.blurRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final deviceType = ResponsiveLayout.getDeviceType(context);

    // Calculate responsive width
    final double containerWidth = width ?? _calculateWidth(screenSize, deviceType);

    return Container(
      width: containerWidth,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: glassColor.withValues(alpha: borderOpacity),
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: glassColor.withValues(alpha: opacity),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  glassColor.withValues(alpha: opacity * 1.3),
                  glassColor.withValues(alpha: opacity * 0.8),
                  glassColor.withValues(alpha: opacity * 0.5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Calculate optimal width based on device type
  double _calculateWidth(Size screenSize, DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobilePortrait:
        // 95% of screen width for mobile portrait
        return screenSize.width * 0.95;

      case DeviceType.mobileLandscape:
        // 85% of screen width for mobile landscape
        return screenSize.width * 0.85;

      case DeviceType.tabletPortrait:
        // Fixed width for tablet portrait, max 600px
        return (screenSize.width * 0.85).clamp(500, 600);

      case DeviceType.tabletLandscape:
        // Fixed width for tablet landscape
        return 700;
    }
  }
}
