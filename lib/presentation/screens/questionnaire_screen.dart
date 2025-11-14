import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/biblical_question.dart';
import '../../providers/questionnaire_provider.dart';
import '../../providers/user_name_provider.dart';
import '../../widgets/video_background.dart';
import '../../widgets/rectangular_liquid_glass_widget.dart';
import '../../widgets/home_button.dart';
import '../../utils/responsive_layout.dart';

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
    final deviceType = ResponsiveLayout.getDeviceType(context);
    final fontScale = ResponsiveLayout.getFontScale(deviceType);
    final isPortrait = ResponsiveLayout.isPortrait(deviceType);
    final portraitFontBoost = isPortrait ? 1.2 : 1.0;
    final isTabletLandscape = deviceType == DeviceType.tabletLandscape;

    if (questionState.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final currentQuestion = questionState.questions[questionState.currentIndex];
    // 셔플된 옵션 가져오기
    final shuffledOptions = ref
        .read(questionnaireProvider.notifier)
        .getShuffledOptions(questionState.currentIndex);
    final progress =
        (questionState.currentIndex + 1) / questionState.questions.length;

    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
        isPortrait: isPortrait,
        child: Stack(
          children: [
            SafeArea(
              child: FadeTransition(
                opacity: _fadeController.drive(
                  CurveTween(curve: Curves.easeOut),
                ),
                child: Column(
                  children: [
                    // 상단 여백 (홈버튼 아래로 배치)
                    SizedBox(height: isPortrait ? 80 : 0),

                    // 상단 헤더 및 진행바
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isPortrait
                            ? 16
                            : (isTabletLandscape ? 40 : 20),
                        vertical: isPortrait
                            ? 12
                            : (isTabletLandscape ? 20 : 15),
                      ),
                      child: Column(
                        children: [
                          // 진행바
                          Container(
                            height: isPortrait ? 5 : 6,
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
                          SizedBox(height: isPortrait ? 10 : 12),
                          // 진행 상황 텍스트
                          Text(
                            '$userName님의 선택 ${questionState.currentIndex + 1} / ${questionState.questions.length}',
                            style: TextStyle(
                              fontFamily: 'SpoqaHanSansNeo',
                              fontSize: isPortrait
                                  ? 13 * fontScale * portraitFontBoost
                                  : (isTabletLandscape ? 16 : 14) * fontScale,
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
                        child: RectangularLiquidGlassWidget(
                          width: isPortrait
                              ? screenSize.width * 0.95
                              : (isTabletLandscape ? 800 : 580),
                          height: isPortrait
                              ? (screenSize.width * 0.95) * 1.6 // 1:1.6 비율
                              : (isTabletLandscape ? 650 : 580),
                          borderRadius: isPortrait ? 25 : 28,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isPortrait
                                  ? 24
                                  : (isTabletLandscape ? 60 : 32),
                              vertical: isPortrait
                                  ? 28
                                  : (isTabletLandscape ? 60 : 40),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Spacer(flex: 2),

                                // 질문 텍스트
                                Text(
                                  currentQuestion.text,
                                  style: TextStyle(
                                    fontFamily: 'SpoqaHanSansNeo',
                                    fontSize: isPortrait
                                        ? 17 * fontScale * portraitFontBoost
                                        : (isTabletLandscape ? 24 : 20) *
                                              fontScale,
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

                                const Spacer(flex: 1),

                                // 답변 버튼들 - 셔플된 옵션 사용
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: isPortrait
                                        ? double.infinity
                                        : (isTabletLandscape ? 600 : 500),
                                  ),
                                  child: Column(
                                    children: List.generate(
                                      shuffledOptions.length,
                                      (index) {
                                        // 셔플된 인덱스를 원본 인덱스로 변환하여 선택 상태 확인
                                        final originalIndex = ref
                                            .read(
                                              questionnaireProvider.notifier,
                                            )
                                            .getOriginalIndex(
                                              questionState.currentIndex,
                                              index,
                                            );
                                        final isSelected = questionState
                                                .selectedAnswers[
                                            questionState.currentIndex] ==
                                        originalIndex;

                                        return FadeTransition(
                                          opacity: _buttonAnimations[index],
                                          child: Transform.translate(
                                            offset: Offset(
                                              0,
                                              (1 -
                                                      _buttonAnimations[index]
                                                          .value) *
                                                  20,
                                            ),
                                            child: _AnswerButton(
                                              option: shuffledOptions[index],
                                              index: index,
                                              isSelected: isSelected,
                                              onTap: () => _selectAnswer(index),
                                              isTabletLandscape:
                                                  isTabletLandscape,
                                              isPortrait: isPortrait,
                                              fontScale: fontScale,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                const Spacer(flex: 2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 하단 여백만
                    SizedBox(
                      height: isPortrait ? 16 : (isTabletLandscape ? 30 : 20),
                    ),
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
  final bool isPortrait;
  final double fontScale;

  const _AnswerButton({
    required this.option,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.isTabletLandscape,
    required this.isPortrait,
    required this.fontScale,
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
            margin: EdgeInsets.symmetric(vertical: widget.isPortrait ? 8 : 6),
            transform: Matrix4.diagonal3Values(
              widget.isSelected ? 1.02 : 1.0,
              widget.isSelected ? 1.02 : 1.0,
              1.0,
            ),
            child: Container(
              height: widget.isPortrait
                  ? 60
                  : (widget.isTabletLandscape ? 80 : 70),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.isPortrait ? 16 : 24,
                          vertical: widget.isPortrait ? 12 : 16,
                        ),
                        child: Row(
                          children: [
                            // 옵션 라벨
                            Container(
                              width: widget.isPortrait ? 36 : 40,
                              height: widget.isPortrait ? 36 : 40,
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
                                    fontSize: widget.isPortrait
                                        ? 14 * widget.fontScale
                                        : (widget.isTabletLandscape ? 18 : 16) *
                                              widget.fontScale,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: widget.isPortrait ? 12 : 20),
                            // 답변 텍스트
                            Expanded(
                              child: Text(
                                widget.option.text,
                                style: TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  color: Colors.white,
                                  fontSize: widget.isPortrait
                                      ? 14 * widget.fontScale
                                      : (widget.isTabletLandscape ? 18 : 16) *
                                            widget.fontScale,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // 선택 표시
                            if (widget.isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: widget.isPortrait
                                    ? 22
                                    : (widget.isTabletLandscape ? 28 : 24),
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
