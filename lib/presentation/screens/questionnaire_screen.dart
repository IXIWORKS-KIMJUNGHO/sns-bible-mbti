import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/biblical_question.dart';
import '../../providers/questionnaire_provider.dart';
import '../../providers/user_name_provider.dart';
import '../../widgets/video_background.dart';
import '../../widgets/circular_liquid_glass_widget.dart';
import '../../widgets/home_button.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _buttonAnimationController;
  late List<Animation<double>> _buttonAnimations;

  @override
  void initState() {
    super.initState();

    // 페이드인 애니메이션
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 버튼 애니메이션 컨트롤러
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 각 버튼의 순차적 애니메이션
    _buttonAnimations = [];
    for (int i = 0; i < 5; i++) {
      _buttonAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _buttonAnimationController,
            curve: Interval(i * 0.1, 0.5 + i * 0.1, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }

    // 애니메이션 시작
    _fadeController.forward();
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    ref.read(questionnaireProvider.notifier).selectAnswer(index);

    // Wait for visual feedback then auto-navigate
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _goToNextQuestion();
      }
    });
  }

  void _goToNextQuestion() {
    // 버튼 애니메이션 리셋
    _buttonAnimationController.reset();

    final hasNext = ref.read(questionnaireProvider.notifier).nextQuestion();

    if (hasNext) {
      // 다음 질문으로 전환
      _buttonAnimationController.forward();
    } else {
      // 결과 화면으로 이동
      context.go('/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionState = ref.watch(questionnaireProvider);
    final userName = ref.watch(userNameProvider);
    final screenSize = MediaQuery.of(context).size;
    final isTabletLandscape =
        screenSize.width > 1500 && screenSize.aspectRatio > 1.2;

    if (questionState.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final currentQuestion = questionState.questions[questionState.currentIndex];
    // 셔플된 옵션 가져오기
    final shuffledOptions = ref.read(questionnaireProvider.notifier).getShuffledOptions(questionState.currentIndex);
    final progress =
        (questionState.currentIndex + 1) / questionState.questions.length;

    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
        child: Stack(
          children: [
            SafeArea(
              child: FadeTransition(
                opacity: _fadeController.drive(
                  CurveTween(curve: Curves.easeOut),
                ),
                child: Column(
                  children: [
                    // 상단 헤더 및 진행바
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTabletLandscape ? 40 : 20,
                        vertical: isTabletLandscape ? 20 : 15,
                      ),
                      child: Column(
                        children: [
                          // 진행바
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 진행 상황 텍스트
                          Text(
                            '$userName님의 선택 ${questionState.currentIndex + 1} / ${questionState.questions.length}',
                            style: TextStyle(
                              fontFamily: 'SpoqaHanSansNeo',
                              fontSize: isTabletLandscape ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 중앙 질문 카드
                    Expanded(
                      child: Center(
                        child: Container(
                          width: isTabletLandscape ? 800 : 580,
                          height: isTabletLandscape ? 800 : 580,
                          child: CircularLiquidGlassWidget(
                            customRadius: isTabletLandscape ? 400 : 290,
                            child: Padding(
                              padding: EdgeInsets.all(
                                isTabletLandscape ? 60 : 25,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 질문 텍스트
                                  Text(
                                    currentQuestion.text,
                                    style: TextStyle(
                                      fontFamily: 'SpoqaHanSansNeo',
                                      fontSize: isTabletLandscape ? 24 : 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.4,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 4.0,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  SizedBox(height: isTabletLandscape ? 30 : 25),

                                  // 답변 버튼들 - 셔플된 옵션 사용
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: isTabletLandscape ? 600 : 500,
                                    ),
                                    child: Column(
                                      children: List.generate(
                                        shuffledOptions.length,
                                        (index) {
                                      // 셔플된 인덱스를 원본 인덱스로 변환하여 선택 상태 확인
                                      final originalIndex = ref.read(questionnaireProvider.notifier)
                                          .getOriginalIndex(questionState.currentIndex, index);
                                      final isSelected = questionState
                                          .selectedAnswers[questionState.currentIndex] == originalIndex;
                                      
                                      return FadeTransition(
                                        opacity: _buttonAnimations[index],
                                        child: Transform.translate(
                                          offset: Offset(
                                            0,
                                            (1 - _buttonAnimations[index].value) * 20,
                                          ),
                                          child: _AnswerButton(
                                            option: shuffledOptions[index],
                                            index: index,
                                            isSelected: isSelected,
                                            onTap: () => _selectAnswer(index),
                                            isTabletLandscape: isTabletLandscape,
                                          ),
                                        ),
                                      );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 하단 여백만
                    SizedBox(height: isTabletLandscape ? 30 : 20),
                  ],
                ),
              ),
            ),

            // Home Button
            const TopRightHomeButton(),
          ],
        ),
      ),
    );
  }
}

// 답변 버튼 위젯
class _AnswerButton extends StatefulWidget {
  final QuestionOption option;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTabletLandscape;

  const _AnswerButton({
    required this.option,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.isTabletLandscape,
  });

  @override
  State<_AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<_AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap();
    });
  }

  String get _optionLabel {
    switch (widget.index) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      case 4:
        return 'E';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 6),
            transform: Matrix4.identity()
              ..scale(
                widget.isSelected ? 1.02 : 1.0,
                widget.isSelected ? 1.02 : 1.0,
              ),
            child: Container(
              height: widget.isTabletLandscape ? 80 : 70,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.3),
                  width: widget.isSelected ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _handleTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            // 옵션 라벨
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _optionLabel,
                                  style: TextStyle(
                                    fontFamily: 'SpoqaHanSansNeo',
                                    color: Colors.white,
                                    fontSize: widget.isTabletLandscape
                                        ? 18
                                        : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // 답변 텍스트
                            Expanded(
                              child: Text(
                                widget.option.text,
                                style: TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  color: Colors.white,
                                  fontSize: widget.isTabletLandscape ? 18 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // 선택 표시
                            if (widget.isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: widget.isTabletLandscape ? 28 : 24,
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
        );
      },
    );
  }
}

// 네비게이션 버튼 위젯
class _NavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _NavigationButton({
    required this.onTap,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Colors.white, Color(0xFFF0F0F0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: isPrimary ? null : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: isPrimary ? 0.8 : 0.3),
          width: isPrimary ? 2 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon == Icons.arrow_back_ios)
                  Icon(
                    icon,
                    color: isPrimary ? const Color(0xFF6B73FF) : Colors.white,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'SpoqaHanSansNeo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isPrimary ? const Color(0xFF6B73FF) : Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                if (icon == Icons.arrow_forward_ios)
                  Icon(
                    icon,
                    color: isPrimary ? const Color(0xFF6B73FF) : Colors.white,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
