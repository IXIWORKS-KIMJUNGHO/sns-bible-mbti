import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/biblical_character.dart';
import '../../providers/character_selection_provider.dart';
import '../../widgets/character_carousel.dart';
import '../../widgets/video_background.dart';

/// 성경인물 선택 화면
/// 
/// iPad 13인치 가로모드에 최적화된 캐러셀 인터페이스
class CharacterSelectionScreen extends ConsumerStatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  ConsumerState<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends ConsumerState<CharacterSelectionScreen>
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
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // 버튼 애니메이션
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

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
    // 버튼 애니메이션 시작
    _buttonController.forward();
  }

  void _onBackPressed() {
    context.go('/');
  }

  void _onContinuePressed() {
    // 다음 화면으로 이동 (추후 구현)
    // context.go('/assessment');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${ref.read(selectedCharacterProvider)?.name} 선택 완료!',
          style: const TextStyle(
            fontFamily: 'SpoqaHanSansNeo',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTabletLandscape = screenSize.width > 1500 && screenSize.aspectRatio > 1.2;
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    final isCharacterSelected = ref.watch(isCharacterSelectedProvider);
    
    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
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
                      horizontal: isTabletLandscape ? 40 : 20,
                      vertical: isTabletLandscape ? 30 : 20,
                    ),
                    child: Row(
                      children: [
                        // Back Button
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _onBackPressed,
                                  borderRadius: BorderRadius.circular(24),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Title
                        Text(
                          '닮고 싶은 성경인물을 선택해주세요',
                          style: TextStyle(
                            fontFamily: 'SpoqaHanSansNeo',
                            fontSize: isTabletLandscape ? 28 : 24,
                            fontWeight: FontWeight.w700,
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
                        
                        const Spacer(),
                        
                        // Spacer for symmetry
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  
                  // Carousel Section
                  Expanded(
                    child: Center(
                      child: CharacterCarousel(
                        characters: BiblicalCharacters.characters,
                        onCharacterSelected: _onCharacterSelected,
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
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 280,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.2),
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
                                        child: Text(
                                          selectedCharacter != null 
                                              ? '${selectedCharacter.name}(으)로 계속하기'
                                              : '계속하기',
                                          style: const TextStyle(
                                            fontFamily: 'SpoqaHanSansNeo',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(1, 1),
                                                blurRadius: 3.0,
                                                color: Colors.black38,
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
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}