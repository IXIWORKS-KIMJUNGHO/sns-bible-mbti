import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_name_provider.dart';
import '../providers/character_selection_provider.dart';
import '../providers/questionnaire_provider.dart';

/// 홈 버튼 위젯 - 모든 상태를 초기화하고 인트로 페이지로 이동
/// 
/// TF 팀이 데모 중 앱을 초기화할 때 사용
class HomeButton extends ConsumerWidget {
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showTooltip;
  
  const HomeButton({
    super.key,
    this.size = 48.0,
    this.backgroundColor,
    this.iconColor,
    this.showTooltip = true,
  });

  /// 모든 프로바이더 상태 초기화
  void _resetAllState(WidgetRef ref) {
    // 사용자 이름 초기화
    ref.read(userNameProvider.notifier).state = '';
    
    // 선택된 캐릭터 초기화
    ref.read(selectedCharacterProvider.notifier).clearSelection();
    
    // 질문지 상태 초기화 (답변, 점수 등)
    ref.read(questionnaireProvider.notifier).reset();
  }

  void _onPressed(BuildContext context, WidgetRef ref) {
    // 바로 상태 초기화하고 홈으로 이동
    _resetAllState(ref);
    context.go('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size! / 2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size! / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onPressed(context, ref),
              borderRadius: BorderRadius.circular(size! / 2),
              child: Icon(
                Icons.home_rounded,
                color: iconColor ?? Colors.white,
                size: size! * 0.5,
              ),
            ),
          ),
        ),
      ),
    );

    if (showTooltip) {
      return Tooltip(
        message: '홈으로 (모든 데이터 초기화)',
        textStyle: const TextStyle(
          fontFamily: 'SpoqaHanSansNeo',
          fontSize: 12,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: button,
      );
    }

    return button;
  }
}

/// 상단 우측에 배치되는 홈 버튼 (기본 스타일)
class TopRightHomeButton extends StatelessWidget {
  const TopRightHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletLandscape = screenSize.width > 1500 && screenSize.aspectRatio > 1.2;
    
    return Positioned(
      top: isTabletLandscape ? 60 : 50,
      right: isTabletLandscape ? 40 : 20,
      child: SafeArea(
        child: HomeButton(
          size: isTabletLandscape ? 56.0 : 48.0,
        ),
      ),
    );
  }
}