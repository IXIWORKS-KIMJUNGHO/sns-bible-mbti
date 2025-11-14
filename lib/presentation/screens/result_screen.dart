import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../providers/questionnaire_provider.dart';
import '../../providers/user_name_provider.dart';
import '../../providers/character_selection_provider.dart';
import '../../widgets/video_background.dart';
import '../../widgets/home_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/improved_trait_comparison.dart';
import '../../widgets/strengths_growth_cards.dart';
import '../../widgets/gesture_scroll_hint.dart';
import '../../widgets/bible_card_qr_modal.dart';
import '../../widgets/loading_video_dialog.dart';
import '../../providers/bible_card_provider.dart';
import '../../models/biblical_character.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_layout.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider);
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    final top3 = ref.read(questionnaireProvider.notifier).getTop3Characters();
    final deviceType = ResponsiveLayout.getDeviceType(context);
    final fontScale = ResponsiveLayout.getFontScale(deviceType);
    final isPortrait = ResponsiveLayout.isPortrait(deviceType);
    final portraitFontBoost = isPortrait ? 1.2 : 1.0;
    final isTabletLandscape = deviceType == DeviceType.tabletLandscape;

    // 매칭된 캐릭터 찾기 (상위 1위)
    BiblicalCharacter? matchedCharacter;
    if (top3.isNotEmpty) {
      final matchedId = top3[0].key; // 이제 ID로 매칭 (예: 'paul')
      matchedCharacter = BiblicalCharacters.characters.firstWhere(
        (character) => character.id == matchedId, // name 대신 id로 매칭
        orElse: () => BiblicalCharacters.characters.first,
      );
    } else {
      // 기본값으로 첫 번째 캐릭터 사용
      matchedCharacter = BiblicalCharacters.characters.first;
    }

    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
        isPortrait: isPortrait,
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // 상단 고정 영역: 헤더와 비교 카드
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isPortrait ? 16 : (isTabletLandscape ? 40 : 20),
                      isPortrait ? 35 : (isTabletLandscape ? 0 : 0),
                      isPortrait ? 16 : (isTabletLandscape ? 40 : 20),
                      0,
                    ),
                    child: Column(
                      children: [
                        // 개인화된 헤더
                        Text(
                          selectedCharacter != null
                              ? '${selectedCharacter.name}을 닮고 싶은 $userName님'
                              : '$userName님',
                          style: AppTypography.withGlassEffect(
                            AppTypography.getResponsive(
                              AppTypography.h1,
                              isTabletLandscape,
                            ).copyWith(
                              fontSize: isPortrait
                                  ? 17 * fontScale * portraitFontBoost
                                  : null,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: isPortrait
                              ? 16
                              : (isTabletLandscape ? 30 : 20),
                        ),

                        // 비교 카드들 (고정 높이)
                        if (selectedCharacter != null &&
                            matchedCharacter != null)
                          SizedBox(
                            height: isPortrait
                                ? 240
                                : (isTabletLandscape ? 350 : 280),
                            child: _ComparisonSection(
                              selectedCharacter: selectedCharacter,
                              matchedCharacter: matchedCharacter,
                              isTabletLandscape: isTabletLandscape,
                              isPortrait: isPortrait,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 스크롤 가능한 콘텐츠 영역
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      primary: false,
                      padding: EdgeInsets.fromLTRB(
                        isPortrait ? 16 : (isTabletLandscape ? 40 : 20),
                        isPortrait ? 10 : (isTabletLandscape ? 20 : 10),
                        isPortrait ? 16 : (isTabletLandscape ? 40 : 20),
                        isPortrait ? 20 : (isTabletLandscape ? 40 : 20),
                      ),
                      child: Column(
                        children: [
                          // 결과 메시지 - "당신의 성경 매칭 인물은 OOO입니다"
                          if (matchedCharacter != null)
                            _DetailedResultMessage(
                              matchedCharacter: matchedCharacter,
                              isTabletLandscape: isTabletLandscape,
                              isPortrait: isPortrait,
                            ),

                          SizedBox(
                            height: isPortrait
                                ? 16
                                : (isTabletLandscape ? 30 : 20),
                          ),

                          // 개선된 성격 특성 비교 섹션
                          if (selectedCharacter != null &&
                              matchedCharacter != null)
                            ImprovedTraitComparison(
                              selectedCharacter: selectedCharacter,
                              matchedCharacter: matchedCharacter,
                              isTabletLandscape: isTabletLandscape,
                            ),

                          SizedBox(
                            height: isPortrait
                                ? 16
                                : (isTabletLandscape ? 30 : 20),
                          ),

                          // 개선된 강점과 성장 영역 섹션
                          if (matchedCharacter != null)
                            StrengthsGrowthCards(
                              matchedCharacter: matchedCharacter,
                              isTabletLandscape: isTabletLandscape,
                            ),

                          SizedBox(
                            height: isPortrait
                                ? 16
                                : (isTabletLandscape ? 30 : 20),
                          ),

                          // 액션 버튼
                          _ActionButtons(
                            onRestart: () {
                              // 모든 상태 초기화 (이름 포함)
                              ref.read(userNameProvider.notifier).state = '';
                              ref.read(questionnaireProvider.notifier).reset();
                              ref
                                  .read(selectedCharacterProvider.notifier)
                                  .clearSelection();
                              ref.read(bibleCardStateProvider.notifier).reset();
                              context.go('/');
                            },
                            onShareBibleVerse: () async {
                              if (matchedCharacter != null) {
                                // 로딩 비디오 표시
                                LoadingVideoDialog.show(context);

                                // 말씀카드 생성
                                await ref
                                    .read(bibleCardStateProvider.notifier)
                                    .generateCard(
                                      characterId: matchedCharacter.id,
                                      userName: userName,
                                      characterName: matchedCharacter.name,
                                    );

                                // 로딩 닫기
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }

                                // 결과 확인
                                final state = ref.read(bibleCardStateProvider);
                                if (state.hostingUrl != null &&
                                    context.mounted) {
                                  // QR 모달 표시 (Firebase Hosting URL 사용)
                                  showBibleCardQRModal(
                                    context: context,
                                    downloadUrl: state.hostingUrl!,
                                    characterName: matchedCharacter.name,
                                    userName: userName,
                                  );
                                } else if (state.error != null &&
                                    context.mounted) {
                                  // 에러 메시지 표시
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        state.error ?? '오류가 발생했습니다',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            isTabletLandscape: isTabletLandscape,
                            isPortrait: isPortrait,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Home Button
            const TopRightHomeButton(),

            // 스크롤 힌트 (iPad용)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: GestureScrollHint(scrollController: _scrollController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 비교 섹션 위젯
class _ComparisonSection extends StatelessWidget {
  final BiblicalCharacter selectedCharacter;
  final BiblicalCharacter matchedCharacter;
  final bool isTabletLandscape;
  final bool isPortrait;

  const _ComparisonSection({
    required this.selectedCharacter,
    required this.matchedCharacter,
    required this.isTabletLandscape,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    // 세로형에서는 매칭 결과만, 가로형에서는 가로 배치
    if (isPortrait) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 매칭 결과 캐릭터만 표시
          _CharacterCard(
            character: matchedCharacter,
            title: "매칭결과",
            isTabletLandscape: isTabletLandscape,
            isPortrait: isPortrait,
          ),
        ],
      );
    }

    // 가로형 레이아웃
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 닮고 싶은 캐릭터 카드
        // 왼쪽: 닮고 싶은 캐릭터 (원형)
        _CharacterCard(
          character: selectedCharacter,
          title: "닮고 싶은 ${selectedCharacter.name}",
          isTabletLandscape: isTabletLandscape,
          isPortrait: isPortrait,
        ),

        SizedBox(width: isTabletLandscape ? 60 : 20),

        // VS 인디케이터
        _VSIndicator(
          isTabletLandscape: isTabletLandscape,
          isPortrait: isPortrait,
        ),

        SizedBox(width: isTabletLandscape ? 60 : 20),

        // 오른쪽: 매칭 결과 캐릭터 (원형)
        _CharacterCard(
          character: matchedCharacter,
          title: "매칭결과 ${matchedCharacter.name}",
          isTabletLandscape: isTabletLandscape,
          isPortrait: isPortrait,
        ),
      ],
    );
  }
}

// 원형 캐릭터 카드 위젯 (간소화된 버전)
class _CharacterCard extends StatefulWidget {
  final BiblicalCharacter character;
  final String title;
  final bool isTabletLandscape;
  final bool isPortrait;

  const _CharacterCard({
    required this.character,
    required this.title,
    required this.isTabletLandscape,
    required this.isPortrait,
  });

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    // 웹이 아닐 때만 비디오 초기화
    if (!kIsWeb) {
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    // Debug logging removed for production
    final videoPath = _getVideoPath(widget.character.id);
    if (videoPath.isNotEmpty) {
      _videoController = VideoPlayerController.asset(videoPath)
        ..initialize()
            .then((_) {
              if (mounted) {
                setState(() {});
                _videoController?.setLooping(true);
                _videoController?.setVolume(0);
                _videoController?.play();
              }
            })
            .catchError((error) {
              // 에러 처리
            });
    }
  }

  String _getVideoPath(String characterId) {
    final Map<String, String> videoMapping = {
      'david': 'David.mp4',
      'esther': 'Esther.mp4',
      'moses': 'Moses.mp4',
      'mary': 'Mary.mp4',
      'joseph': 'Joseph.mp4',
      'paul': 'Paul.mp4',
      'daniel': 'Daniel.mp4',
      'solomon': 'Solomon.mp4',
      'deborah': 'Deborah.mp4',
      'barnabas': 'Barnabas.mp4',
      'luke': 'Luke.mp4',
      'jeremiah': 'Jeremiah.mp4',
      'noah': 'Noah.mp4',
      'rebekah': 'Rebekah.mp4',
      'prodigal_son': 'ProdigalSon.mp4',
      'peter': 'Peter.mp4',
    };

    final fileName = videoMapping[characterId];
    if (fileName != null) {
      return 'assets/videos/bible_people/$fileName';
    }
    return '';
  }

  String _getGifPath(String characterId) {
    final Map<String, String> gifMapping = {
      'david': 'David.gif',
      'esther': 'Esther.gif',
      'moses': 'Moses.gif',
      'mary': 'Mary.gif',
      'joseph': 'Joseph.gif',
      'paul': 'Paul.gif',
      'daniel': 'Daniel.gif',
      'solomon': 'Solomon.gif',
      'deborah': 'Deborah.gif',
      'barnabas': 'Barnabas.gif',
      'luke': 'Luke.gif',
      'jeremiah': 'Jeremiah.gif',
      'noah': 'Noah.gif',
      'rebekah': 'Rebekah.gif',
      'prodigal_son': 'ProdigalSon.gif',
      'peter': 'Peter.gif',
    };

    final fileName = gifMapping[characterId];
    if (fileName != null) {
      return 'assets/videos/bible_people_gif/$fileName';
    }
    return '';
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (isHovered) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  Widget _buildWebCharacterImage() {
    final gifPath = _getGifPath(widget.character.id);
    if (gifPath.isEmpty) {
      return Icon(
        Icons.person_outline,
        size: widget.isPortrait ? 80 : (widget.isTabletLandscape ? 120 : 100),
        color: Colors.white.withValues(alpha: 0.6),
      );
    }
    return Image.asset(
      gifPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.person_outline,
          size: widget.isPortrait ? 80 : (widget.isTabletLandscape ? 120 : 100),
          color: Colors.white.withValues(alpha: 0.6),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 세로형: 190px, 가로형: 기존 크기
    final cardSize = widget.isPortrait
        ? 190.0
        : (widget.isTabletLandscape ? 280.0 : 220.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 상단 라벨 (닮고 싶은 OOO 또는 매칭결과 OOO)
        Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'SpoqaHanSansNeo',
            fontSize: widget.isPortrait
                ? 15
                : (widget.isTabletLandscape ? 13 : 12),
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: const [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 4.0,
                color: Colors.black38,
              ),
            ],
          ),
        ),

        SizedBox(
          height: widget.isPortrait ? 12 : (widget.isTabletLandscape ? 20 : 16),
        ),

        // 원형 비디오 플레이어
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) => _handleHover(true),
                onExit: (_) => _handleHover(false),
                child: Container(
                  width: cardSize,
                  height: cardSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: kIsWeb
                          ? _buildWebCharacterImage()
                          : (_videoController != null &&
                                  _videoController!.value.isInitialized
                              ? FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _videoController!.value.size.width,
                                    height: _videoController!.value.size.height,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                )
                              : Icon(
                                  Icons.person_outline,
                                  size: widget.isPortrait
                                      ? 80
                                      : (widget.isTabletLandscape ? 120 : 100),
                                  color: Colors.white.withValues(alpha: 0.6),
                                )),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// VS 인디케이터 위젯
class _VSIndicator extends StatelessWidget {
  final bool isTabletLandscape;
  final bool isPortrait;

  const _VSIndicator({
    required this.isTabletLandscape,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorSize = isPortrait ? 50.0 : (isTabletLandscape ? 80.0 : 60.0);

    return Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 3,
        ),
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Text(
              'VS',
              style: TextStyle(
                fontFamily: 'SpoqaHanSansNeo',
                fontSize: isPortrait ? 14 : (isTabletLandscape ? 20 : 16),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 상세 결과 메시지 위젯
class _DetailedResultMessage extends StatelessWidget {
  final BiblicalCharacter matchedCharacter;
  final bool isTabletLandscape;
  final bool isPortrait;

  const _DetailedResultMessage({
    required this.matchedCharacter,
    required this.isTabletLandscape,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GlassCard(
      width: isPortrait
          ? screenWidth * 0.9
          : (isTabletLandscape ? screenWidth * 0.7 : screenWidth * 0.9),
      padding: EdgeInsets.all(isPortrait ? 18 : (isTabletLandscape ? 32 : 24)),
      backgroundColor: AppColors.glassMedium,
      borderColor: AppColors.borderMedium,
      borderWidth: 1,
      child: Column(
        children: [
          Text(
            "당신의 성경 매칭 인물은",
            style: AppTypography.withGlassEffect(
              AppTypography.getResponsive(
                AppTypography.body,
                isTabletLandscape,
              ),
            ).copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            "${matchedCharacter.name}입니다",
            style: AppTypography.withGlassEffect(
              AppTypography.getResponsive(
                AppTypography.hero,
                isTabletLandscape,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Text(
              matchedCharacter.description,
              style: AppTypography.withGlassEffect(
                AppTypography.getResponsive(
                  AppTypography.body,
                  isTabletLandscape,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassLight,
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.format_quote,
                  color: AppColors.textTertiary,
                  size: 15,
                ),
                const SizedBox(height: 5),
                Text(
                  matchedCharacter.bibleVerse,
                  style: AppTypography.withGlassEffect(
                    AppTypography.getResponsive(
                      AppTypography.body,
                      isTabletLandscape,
                    ),
                  ).copyWith(fontStyle: FontStyle.italic, height: 1.3),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  matchedCharacter.verseReference,
                  style: AppTypography.withGlassEffect(
                    AppTypography.caption,
                  ).copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 액션 버튼들 위젯
class _ActionButtons extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onShareBibleVerse;
  final bool isTabletLandscape;
  final bool isPortrait;

  const _ActionButtons({
    required this.onRestart,
    required this.onShareBibleVerse,
    required this.isTabletLandscape,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    // 세로형에서는 세로 스택, 가로형에서는 가로 배치
    if (isPortrait) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 다시 시작하기 버튼
          _buildButton(
            onTap: onRestart,
            text: '다시 시작하기',
            icon: Icons.refresh,
            isTabletLandscape: isTabletLandscape,
            isPortrait: isPortrait,
          ),

          SizedBox(height: 12),

          // 말씀카드 받기 버튼
          _buildButton(
            onTap: onShareBibleVerse,
            text: '말씀카드 받기',
            icon: Icons.qr_code_2,
            isTabletLandscape: isTabletLandscape,
            isPortrait: isPortrait,
          ),
        ],
      );
    }

    // 가로형 레이아웃
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 다시 시작하기 버튼
        _buildButton(
          onTap: onRestart,
          text: '다시 시작하기',
          icon: Icons.refresh,
          isTabletLandscape: isTabletLandscape,
          isPortrait: isPortrait,
        ),

        SizedBox(width: isTabletLandscape ? 20 : 16),

        // 말씀카드 받기 버튼
        _buildButton(
          onTap: onShareBibleVerse,
          text: '말씀카드 받기',
          icon: Icons.qr_code_2,
          isTabletLandscape: isTabletLandscape,
          isPortrait: isPortrait,
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    required String text,
    required IconData icon,
    required bool isTabletLandscape,
    required bool isPortrait,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isPortrait ? 20 : (isTabletLandscape ? 32 : 24),
                  vertical: isPortrait ? 14 : (isTabletLandscape ? 20 : 16),
                ),
                child: Row(
                  mainAxisSize: isPortrait
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: isPortrait ? 18 : (isTabletLandscape ? 24 : 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'SpoqaHanSansNeo',
                        fontSize: isPortrait
                            ? 15
                            : (isTabletLandscape ? 18 : 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
