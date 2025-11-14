import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/rectangular_liquid_glass_widget.dart';
import '../../widgets/video_background.dart';
import '../../providers/user_name_provider.dart';
import '../../utils/responsive_layout.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 화면이 열릴 때 이름 상태 초기화 (이전 사용자 이름 제거)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNameProvider.notifier).state = '';
      _nameController.clear();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNameValid = ref.watch(isNameValidProvider);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final deviceType = ResponsiveLayout.getDeviceType(context);
    final fontScale = ResponsiveLayout.getFontScale(deviceType);
    final screenSize = MediaQuery.of(context).size;

    // Portrait mode에서 폰트 크기 20% 증가 (입력 필드와 버튼 제외)
    final isPortrait = ResponsiveLayout.isPortrait(deviceType);
    final portraitFontBoost = isPortrait ? 1.2 : 1.0;

    // Calculate widget dimensions with aspect ratio
    final widgetWidth = screenSize.width * 0.95;
    final widgetHeight = widgetWidth * 1.6 * 0.85; // 세로 길이 85%

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
        isPortrait: isPortrait,
        child: Stack(
          children: [
            // Scrollable content to prevent overflow
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: RectangularLiquidGlassWidget(
                  width: widgetWidth,
                  height: widgetHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isMobile(deviceType) ? 24 : 32,
                      vertical: ResponsiveLayout.isMobile(deviceType) ? 50 : 60,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Spacer(flex: 2),

                        // Title
                        Text(
                          '성경 인물 매칭',
                          style: TextStyle(
                            fontFamily: 'SpoqaHanSansNeo',
                            fontSize: 32 * fontScale * portraitFontBoost,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(255, 255, 255, 1),
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

                        // Description
                        Text(
                          '"믿음의 선택들을 통해\n나와 비슷한 성경 인물을 만나보세요"',
                          style: TextStyle(
                            fontFamily: 'SpoqaHanSansNeo',
                            fontSize: 16 * fontScale * portraitFontBoost,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.5,
                            shadows: const [
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2.0,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const Spacer(flex: 2),

                        // 구분선
                        Container(
                          width: 60,
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0),
                                Colors.white.withValues(alpha: 0.3),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Name Input Instruction
                        Text(
                          '이름을 입력하고 시작해주세요',
                          style: TextStyle(
                            fontFamily: 'SpoqaHanSansNeo',
                            fontSize: 14 * fontScale * portraitFontBoost,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2.0,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // Name Input Field
                        Container(
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SpoqaHanSansNeo',
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: '이름',
                              hintStyle: TextStyle(
                                fontFamily: 'SpoqaHanSansNeo',
                                fontSize: 16 * fontScale,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            onChanged: (value) {
                              ref.read(userNameProvider.notifier).state = value;
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Start Button
                        AnimatedOpacity(
                          opacity: isNameValid ? 1.0 : 0.5,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 160),
                            height: ResponsiveLayout.getButtonHeight(deviceType) * 0.87,
                            decoration: BoxDecoration(
                              gradient: isNameValid
                                  ? const LinearGradient(
                                      colors: [Colors.white, Color(0xFFF0F0F0)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null,
                              color: isNameValid
                                  ? null
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: isNameValid
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(26),
                                onTap: isNameValid
                                    ? () {
                                        // 키보드 숨기기
                                        FocusScope.of(context).unfocus();
                                        // 다음 화면으로 이동
                                        context.go('/character-selection');
                                      }
                                    : null,
                                child: Center(
                                  child: Text(
                                    '시작하기',
                                    style: TextStyle(
                                      fontFamily: 'SpoqaHanSansNeo',
                                      fontSize: 18 * fontScale * 0.8,
                                      fontWeight: FontWeight.w600,
                                      color: isNameValid
                                          ? const Color(0xFF6B73FF)
                                          : Colors.white.withValues(alpha: 0.7),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }
}
