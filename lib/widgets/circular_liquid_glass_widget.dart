import 'dart:ui';
import 'package:flutter/material.dart';

/// Circular liquid glass widget optimized for iPad 13-inch landscape mode
/// 
/// Provides a glassmorphism effect with proper sizing for intro page content
class CircularLiquidGlassWidget extends StatelessWidget {
  final Widget child;
  final double? customRadius;
  final Color glassColor;
  final double opacity;
  final double borderOpacity;
  final double blurRadius;
  final EdgeInsets contentPadding;

  const CircularLiquidGlassWidget({
    super.key,
    required this.child,
    this.customRadius,
    this.glassColor = Colors.white,
    this.opacity = 0.15,
    this.borderOpacity = 0.3,
    this.blurRadius = 15.0,
    this.contentPadding = const EdgeInsets.all(40.0),
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletLandscape = screenSize.width > 1500 && screenSize.aspectRatio > 1.2;
    
    // Calculate optimal radius for iPad 13-inch landscape (2064x1536)
    final double radius = customRadius ?? _calculateOptimalRadius(screenSize, isTabletLandscape);
    
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: glassColor.withValues(alpha: borderOpacity),
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glassColor.withValues(alpha: opacity),
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.3),
                radius: 1.2,
                colors: [
                  glassColor.withValues(alpha: opacity * 1.5),
                  glassColor.withValues(alpha: opacity * 0.8),
                  glassColor.withValues(alpha: opacity * 0.3),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Padding(
              padding: contentPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Calculates optimal radius based on device specifications and content needs
  double _calculateOptimalRadius(Size screenSize, bool isTabletLandscape) {
    if (isTabletLandscape) {
      // iPad 13-inch landscape optimization
      // Screen: 2064x1536, safe area considerations
      final double maxRadius = screenSize.height * 0.45; // 45% of height for good proportions
      final double minRadius = 300.0; // Minimum for content readability
      
      // Calculate based on content needs
      final double contentBasedRadius = _calculateContentBasedRadius();
      
      return contentBasedRadius.clamp(minRadius, maxRadius);
    } else {
      // Fallback for other devices
      final double smallerDimension = screenSize.width < screenSize.height 
          ? screenSize.width 
          : screenSize.height;
      return smallerDimension * 0.4;
    }
  }

  /// Calculates radius based on expected content requirements
  double _calculateContentBasedRadius() {
    // Base calculation for app intro content:
    // - App title (large text)
    // - Description (medium text, 2-3 lines)
    // - Start button (standard size)
    // - Comfortable spacing
    
    const double titleHeight = 60.0;
    const double descriptionHeight = 100.0;
    const double buttonHeight = 56.0;
    const double spacingTotal = 80.0;
    const double paddingVertical = 80.0; // contentPadding.vertical
    
    final double contentHeight = titleHeight + descriptionHeight + buttonHeight + spacingTotal + paddingVertical;
    
    // Circle radius needs to accommodate diagonal content layout
    // Using pythagorean theorem approximation for circular content
    return (contentHeight / 1.4); // Adjusted for circular geometry
  }
}

/// Pre-configured widget for app intro page
class IntroLiquidGlassWidget extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onStartPressed;
  final String startButtonText;

  const IntroLiquidGlassWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onStartPressed,
    this.startButtonText = '시작하기',
  });

  @override
  State<IntroLiquidGlassWidget> createState() => _IntroLiquidGlassWidgetState();
}

class _IntroLiquidGlassWidgetState extends State<IntroLiquidGlassWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Circle noise pulse animation - very subtle
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _circleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.008, // Very subtle 0.8% scale change
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeInOut,
    ));

    // Start subtle pulse animations with slight offset
    _pulseController.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 300), () {
      _circleController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _circleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _circleAnimation.value,
          child: CircularLiquidGlassWidget(
            child: Column(
        children: [
          // Top spacer to push content up
          const Spacer(flex: 1),
          
          // App Title
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'SpoqaHanSansNeo',
              fontSize: 40,
              fontWeight: FontWeight.w700, // Bold
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.2,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 4.0,
                  color: Colors.black38,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // Description
          Text(
            widget.description,
            style: const TextStyle(
              fontFamily: 'SpoqaHanSansNeo',
              fontSize: 14,
              fontWeight: FontWeight.w400, // Regular
              color: Colors.white,
              height: 1.6,
              letterSpacing: 0.2,
              shadows: [
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 2.0,
                  color: Colors.black26,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 20),
          
          // Animated Start Button with glassmorphism
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: SizedBox(
                  width: 200, // Reduced button width
                  height: 48,  // Reduced button height
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onStartPressed,
                            borderRadius: BorderRadius.circular(24),
                            child: Center(
                              child: Text(
                                widget.startButtonText,
                                style: const TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500, // Medium
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 2.0,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Bottom spacer
          const Spacer(flex: 1),
            ],
          ),
        ),
        );
      },
    );
  }
}

/// Alternative glass effect with more subtle appearance
class SubtleLiquidGlassWidget extends StatelessWidget {
  final Widget child;
  final double? customRadius;

  const SubtleLiquidGlassWidget({
    super.key,
    required this.child,
    this.customRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CircularLiquidGlassWidget(
      customRadius: customRadius,
      opacity: 0.08,
      borderOpacity: 0.2,
      blurRadius: 15.0,
      glassColor: Colors.white,
      child: child,
    );
  }
}

/// Vibrant glass effect for more prominent appearance
class VibrantLiquidGlassWidget extends StatelessWidget {
  final Widget child;
  final double? customRadius;
  final Color accentColor;

  const VibrantLiquidGlassWidget({
    super.key,
    required this.child,
    this.customRadius,
    this.accentColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CircularLiquidGlassWidget(
      customRadius: customRadius,
      opacity: 0.25,
      borderOpacity: 0.4,
      blurRadius: 25.0,
      glassColor: accentColor,
      child: child,
    );
  }
}