import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiquidGlassBackground extends StatefulWidget {
  final Widget child;
  
  const LiquidGlassBackground({
    super.key,
    required this.child,
  });

  @override
  State<LiquidGlassBackground> createState() => _LiquidGlassBackgroundState();
}

class _LiquidGlassBackgroundState extends State<LiquidGlassBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: LiquidGlassPainter(_animation.value),
          child: widget.child,
        );
      },
    );
  }
}

class LiquidGlassPainter extends CustomPainter {
  final double animationValue;

  LiquidGlassPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // 투명한 오버레이 그라데이션 (배경 이미지가 보이도록)
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 1.5,
        colors: [
          const Color(0xFF667eea).withValues(alpha: 0.2),
          const Color(0xFF764ba2).withValues(alpha: 0.3),
          const Color(0xFF6B73FF).withValues(alpha: 0.4),
          const Color(0xFF9B59B6).withValues(alpha: 0.3),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 유동적인 형태들 그리기
    _drawLiquidShapes(canvas, size);
  }

  void _drawLiquidShapes(Canvas canvas, Size size) {

    // 첫 번째 유동적 형태
    _drawBlobShape(
      canvas,
      size,
      Offset(size.width * 0.2, size.height * 0.3 + math.sin(animationValue * 2 * math.pi) * 20),
      size.width * 0.4,
      [
        const Color(0xFFFFFFFF).withValues(alpha: 0.1),
        const Color(0xFF667eea).withValues(alpha: 0.2),
      ],
    );

    // 두 번째 유동적 형태
    _drawBlobShape(
      canvas,
      size,
      Offset(size.width * 0.7, size.height * 0.6 + math.cos(animationValue * 2 * math.pi) * 30),
      size.width * 0.5,
      [
        const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        const Color(0xFF9B59B6).withValues(alpha: 0.15),
      ],
    );

    // 세 번째 유동적 형태
    _drawBlobShape(
      canvas,
      size,
      Offset(size.width * 0.1, size.height * 0.8 + math.sin(animationValue * 1.5 * math.pi) * 15),
      size.width * 0.3,
      [
        const Color(0xFFFFFFFF).withValues(alpha: 0.12),
        const Color(0xFF764ba2).withValues(alpha: 0.18),
      ],
    );
  }

  void _drawBlobShape(Canvas canvas, Size size, Offset center, double radius, List<Color> colors) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: colors,
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final path = Path();
    
    // 불규칙한 원형 모양 생성
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final randomRadius = radius * (0.7 + 0.3 * math.sin(animationValue * 3 * math.pi + i));
      final x = center.dx + randomRadius * math.cos(angle);
      final y = center.dy + randomRadius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}