import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/biblical_character.dart';
import '../../providers/character_selection_provider.dart';
import '../../providers/user_name_provider.dart';
import '../../widgets/character_carousel.dart';
import '../../widgets/video_background.dart';
import '../../widgets/home_button.dart';
import '../../utils/responsive_layout.dart';

/// 성경인물 선택 화면
///
/// iPad 13인치 가로모드에 최적화된 캐러셀 인터페이스
class CharacterSelectionScreen extends ConsumerStatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  ConsumerState<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState
    extends ConsumerState<CharacterSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    // 페이드인 애니메이션
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // 버튼 애니메이션
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    // 애니메이션 시작
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onCharacterSelected(BiblicalCharacter character) {
    // 선택된 캐릭터 저장
    ref.read(selectedCharacterProvider.notifier).selectCharacter(character);

    // 버튼 애니메이션 시작
    _buttonController.forward();
  }

  void _onBackPressed() {
    context.go('/');
  }

  void _onContinuePressed() {
    // 질문지 화면으로 이동
    context.go('/questionnaire');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final deviceType = ResponsiveLayout.getDeviceType(context);
    final fontScale = ResponsiveLayout.getFontScale(deviceType);
    final isPortrait = ResponsiveLayout.isPortrait(deviceType);
    final portraitFontBoost = isPortrait ? 1.2 : 1.0;
    final isTabletLandscape = deviceType == DeviceType.tabletLandscape;
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    final isCharacterSelected = ref.watch(isCharacterSelectedProvider);
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
        isPortrait: isPortrait,
        child: Stack(
          children: [
            // Main Content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isPortrait
                            ? 16
                            : (isTabletLandscape ? 40 : 20),
                        vertical: isPortrait
                            ? 16
                            : (isTabletLandscape ? 30 : 20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back Button
                          Container(
                            width: isPortrait ? 40 : 48,
                            height: isPortrait ? 40 : 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                isPortrait ? 20 : 24,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                isPortrait ? 20 : 24,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _onBackPressed,
                                    borderRadius: BorderRadius.circular(
                                      isPortrait ? 20 : 24,
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: isPortrait ? 18 : 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Title with user name (centered)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                userName.isNotEmpty
                                    ? isPortrait
                                          ? '$userName님,\n닮고 싶은 성경인물을\n선택해주세요'
                                          : '$userName님, 닮고 싶은 성경인물을 선택해주세요'
                                    : isPortrait
                                    ? '닮고 싶은 성경인물을\n선택해주세요'
                                    : '닮고 싶은 성경인물을 선택해주세요',
                                style: TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  fontSize: isPortrait
                                      ? 16 * fontScale * portraitFontBoost
                                      : (isTabletLandscape ? 28 : 20) *
                                            fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: isPortrait ? 1.3 : 1.0,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 4.0,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: isPortrait ? 3 : 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          // Spacer for home button (same width as back button)
                          SizedBox(width: isPortrait ? 40 : 48),
                        ],
                      ),
                    ),

                    // Carousel Section
                    Expanded(
                      child: Center(
                        child: CharacterCarousel(
                          characters: BiblicalCharacters.characters,
                          onCharacterSelected: _onCharacterSelected,
                          deviceType: deviceType,
                        ),
                      ),
                    ),

                    // Continue Button
                    if (isCharacterSelected)
                      AnimatedBuilder(
                        animation: _buttonAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonAnimation.value,
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: isTabletLandscape ? 40 : 30,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    width:
                                        screenSize.width *
                                        (isPortrait ? 0.75 : 0.4),
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                      minWidth: 280,
                                    ),
                                    height: isPortrait
                                        ? 56
                                        : ResponsiveLayout.getButtonHeight(
                                            deviceType,
                                          ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _onContinuePressed,
                                        borderRadius: BorderRadius.circular(28),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              selectedCharacter != null
                                                  ? '${selectedCharacter.name}(으)로 계속하기'
                                                  : '계속하기',
                                              style: TextStyle(
                                                fontFamily: 'SpoqaHanSansNeo',
                                                fontSize: isPortrait
                                                    ? 16
                                                    : 16 * fontScale,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                                shadows: const [
                                                  Shadow(
                                                    offset: Offset(1, 1),
                                                    blurRadius: 3.0,
                                                    color: Colors.black38,
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
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
