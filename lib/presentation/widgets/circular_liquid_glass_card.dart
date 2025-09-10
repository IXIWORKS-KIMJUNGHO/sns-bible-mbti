import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class CircularLiquidGlassCard extends StatefulWidget {
  final Widget child;
  final double size;
  final EdgeInsetsGeometry? padding;
  final double glassOpacity;
  final double blurIntensity;
  final bool enableShimmer;
  final Duration animationDuration;

  const CircularLiquidGlassCard({
    super.key,
    required this.child,
    this.size = 400,
    this.padding,
    this.glassOpacity = 0.06,
    this.blurIntensity = 45.0,
    this.enableShimmer = true,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<CircularLiquidGlassCard> createState() => _CircularLiquidGlassCardState();
}

class _CircularLiquidGlassCardState extends State<CircularLiquidGlassCard>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _glowController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    if (widget.enableShimmer) {
      _shimmerController.repeat();
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shimmerController, _glowController]),
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // Main circular glass container
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Outer glow
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1 * _glowAnimation.value),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                    // Soft shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    children: [
                      // Backdrop blur effect
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: widget.blurIntensity,
                          sigmaY: widget.blurIntensity,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.topLeft,
                              radius: 1.0,
                              colors: [
                                Colors.white.withValues(alpha: widget.glassOpacity * 1.5),
                                Colors.white.withValues(alpha: widget.glassOpacity * 0.8),
                                Colors.white.withValues(alpha: widget.glassOpacity * 0.3),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      
                      // Inner highlight
                      Positioned(
                        top: widget.size * 0.05,
                        left: widget.size * 0.05,
                        child: Container(
                          width: widget.size * 0.4,
                          height: widget.size * 0.4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.3 * _glowAnimation.value),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Shimmer effect
                      if (widget.enableShimmer)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ShimmerPainter(
                              progress: _shimmerAnimation.value,
                              size: widget.size,
                            ),
                          ),
                        ),

                      // Content
                      Positioned.fill(
                        child: Padding(
                          padding: widget.padding ?? EdgeInsets.all(widget.size * 0.12),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShimmerPainter extends CustomPainter {
  final double progress;
  final double size;

  ShimmerPainter({required this.progress, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        stops: [
          math.max(0.0, progress - 0.3),
          progress,
          math.min(1.0, progress + 0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size, size));

    final path = Path()..addOval(Rect.fromLTWH(0, 0, size, size));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Animated version with built-in animation control
class AnimatedCircularLiquidGlassCard extends StatefulWidget {
  final Widget child;
  final double size;
  final EdgeInsetsGeometry? padding;
  final double glassOpacity;
  final double blurIntensity;
  final Duration animationDuration;

  const AnimatedCircularLiquidGlassCard({
    super.key,
    required this.child,
    this.size = 400,
    this.padding,
    this.glassOpacity = 0.06,
    this.blurIntensity = 45.0,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<AnimatedCircularLiquidGlassCard> createState() => _AnimatedCircularLiquidGlassCardState();
}

class _AnimatedCircularLiquidGlassCardState extends State<AnimatedCircularLiquidGlassCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    // Start entrance animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: CircularLiquidGlassCard(
            size: widget.size,
            padding: widget.padding,
            glassOpacity: widget.glassOpacity,
            blurIntensity: widget.blurIntensity,
            animationDuration: widget.animationDuration,
            child: widget.child,
          ),
        );
      },
    );
  }
}