import 'package:flutter/material.dart';
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double opacity;
  final double blur;
  final List<Color>? borderGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.05,
    this.blur = 5.0,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.8,
              ),
              boxShadow: [
                // 아래쪽 그림자 (깊이감)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
                // 위쪽 하이라이트 (유리 반사)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, -8),
                ),
                // 내부 글로우 효과
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AnimatedGlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration animationDuration;

  const AnimatedGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.1,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GlassCard(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            margin: widget.margin,
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}