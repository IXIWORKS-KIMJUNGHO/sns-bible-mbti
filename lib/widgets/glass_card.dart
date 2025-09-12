import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable glass card widget with liquid glass effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double borderRadius;
  final double blurAmount;
  final bool hasBorder;
  final double? borderWidth;
  final Color? borderColor;
  
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius = 20,
    this.blurAmount = 15,
    this.hasBorder = true,
    this.borderWidth,
    this.borderColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.glassLight,
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(
                color: borderColor ?? AppColors.borderLight,
                width: borderWidth ?? 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.glowWhite,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Glass card with subtle tint color
class TintedGlassCard extends StatelessWidget {
  final Widget child;
  final Color tintColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double borderRadius;
  
  const TintedGlassCard({
    super.key,
    required this.child,
    required this.tintColor,
    this.padding,
    this.margin,
    this.width,
    this.borderRadius = 16,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tintColor.withValues(alpha: 0.08),
            tintColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}