import 'package:flutter/material.dart';
import 'dart:ui';

class AdvancedGlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double opacity;
  final double blur;
  final Color? glassColor;
  final double lightIntensity;
  final double shimmerOpacity;

  const AdvancedGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.12,
    this.blur = 25.0,
    this.glassColor,
    this.lightIntensity = 0.3,
    this.shimmerOpacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(20);
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Stack(
        children: [
          // 메인 글래스 레이어
          ClipRRect(
            borderRadius: effectiveBorderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                padding: padding ?? const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: effectiveBorderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: opacity * 1.2),
                      Colors.white.withValues(alpha: opacity * 0.8),
                      Colors.white.withValues(alpha: opacity * 0.6),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                  boxShadow: [
                    // 메인 드롭 섀도우
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: -2,
                    ),
                    // 내부 섀도우 (상단)
                    BoxShadow(
                      color: Colors.white.withValues(alpha: lightIntensity),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                      spreadRadius: -8,
                    ),
                    // 내부 섀도우 (하단)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
          
          // 상단 하이라이트 (유리 반사)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: effectiveBorderRadius.topLeft,
                topRight: effectiveBorderRadius.topRight,
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: shimmerOpacity),
                      Colors.white.withValues(alpha: shimmerOpacity * 0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          
          // 좌측 하이라이트 (측면 반사)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: effectiveBorderRadius.topLeft,
                bottomLeft: effectiveBorderRadius.bottomLeft,
              ),
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withValues(alpha: shimmerOpacity * 0.8),
                      Colors.white.withValues(alpha: shimmerOpacity * 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedAdvancedGlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration animationDuration;

  const AnimatedAdvancedGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.animationDuration = const Duration(seconds: 4),
  });

  @override
  State<AnimatedAdvancedGlassCard> createState() => _AnimatedAdvancedGlassCardState();
}

class _AnimatedAdvancedGlassCardState extends State<AnimatedAdvancedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _lightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: 0.10,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _lightAnimation = Tween<double>(
      begin: 0.2,
      end: 0.4,
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
        return AdvancedGlassCard(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          shimmerOpacity: _shimmerAnimation.value,
          lightIntensity: _lightAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}