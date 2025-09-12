import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// iPad 전용 제스처 스크롤 힌트 위젯
class GestureScrollHint extends StatefulWidget {
  final ScrollController scrollController;
  
  const GestureScrollHint({
    super.key,
    required this.scrollController,
  });
  
  @override
  State<GestureScrollHint> createState() => _GestureScrollHintState();
}

class _GestureScrollHintState extends State<GestureScrollHint>
    with TickerProviderStateMixin {
  late AnimationController _handController;
  late AnimationController _pulseController;
  late Animation<double> _handAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isVisible = true;
  double _scrollOpacity = 1.0;
  
  @override
  void initState() {
    super.initState();
    
    // 손 모양 스와이프 애니메이션
    _handController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _handAnimation = Tween<double>(
      begin: 0,
      end: -40,
    ).animate(CurvedAnimation(
      parent: _handController,
      curve: const Interval(
        0.0, 0.5,
        curve: Curves.easeInOutCubic,
      ),
    ));
    
    // 펄스 애니메이션 (원 확대/축소)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // 페이드 애니메이션
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _handController,
      curve: const Interval(
        0.5, 1.0,
        curve: Curves.easeIn,
      ),
    ));
    
    // 스크롤 감지
    widget.scrollController.addListener(_handleScroll);
    
    // 3초 후 자동으로 약간 투명하게
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isVisible) {
        setState(() {
          _scrollOpacity = 0.6;
        });
      }
    });
  }
  
  void _handleScroll() {
    final offset = widget.scrollController.offset;
    
    // 스크롤이 50픽셀 이상 되면 완전히 사라짐
    if (offset > 50 && _isVisible) {
      setState(() {
        _isVisible = false;
      });
    } else if (offset <= 50 && !_isVisible) {
      setState(() {
        _isVisible = true;
        _scrollOpacity = 0.6;
      });
    }
  }
  
  @override
  void dispose() {
    _handController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();
    
    return AnimatedOpacity(
      opacity: _scrollOpacity,
      duration: const Duration(milliseconds: 300),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _handAnimation,
          _pulseAnimation,
          _fadeAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.glassWhite.withValues(alpha: 0.2),
                    AppColors.glassWhite.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.glowWhite,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 배경 원형 펄스
                  Opacity(
                    opacity: _fadeAnimation.value * 0.3,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.glassWhite.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  
                  // 손가락 아이콘과 화살표
                  Transform.translate(
                    offset: Offset(0, _handAnimation.value),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 텍스트가 포함된 스크롤 힌트 (더 명확한 안내)
class ScrollHintWithText extends StatefulWidget {
  final ScrollController scrollController;
  
  const ScrollHintWithText({
    super.key,
    required this.scrollController,
  });
  
  @override
  State<ScrollHintWithText> createState() => _ScrollHintWithTextState();
}

class _ScrollHintWithTextState extends State<ScrollHintWithText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isVisible = true;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _slideAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    widget.scrollController.addListener(_handleScroll);
  }
  
  void _handleScroll() {
    final offset = widget.scrollController.offset;
    if (offset > 30 && _isVisible) {
      setState(() {
        _isVisible = false;
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.glassMedium,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowWhite,
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swipe_vertical_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '위아래로 스와이프',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}