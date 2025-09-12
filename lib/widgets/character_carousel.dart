import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/biblical_character.dart';
import '../providers/character_selection_provider.dart';
import 'character_carousel_card.dart';

/// 성경인물 선택 캐러셀 위젯
/// 
/// iPad 13인치 가로모드에 최적화된 horizontal scrollable carousel
class CharacterCarousel extends ConsumerStatefulWidget {
  final List<BiblicalCharacter> characters;
  final Function(BiblicalCharacter) onCharacterSelected;

  const CharacterCarousel({
    super.key,
    required this.characters,
    required this.onCharacterSelected,
  });

  @override
  ConsumerState<CharacterCarousel> createState() => _CharacterCarouselState();
}

class _CharacterCarouselState extends ConsumerState<CharacterCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideController;
  double _currentPage = 0.0;
  int _currentIndex = 0;
  
  // 무한 스크롤을 위한 가상 리스트 크기
  static const int _virtualListSize = 10000;
  late int _initialPage;

  @override
  void initState() {
    super.initState();
    
    // 중앙에서 시작하도록 설정 - 무한 스크롤을 위해 큰 수로 시작
    _currentIndex = widget.characters.length ~/ 2;
    _initialPage = _virtualListSize ~/ 2;
    _currentPage = _initialPage.toDouble();
    
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.2, // 5개 카드가 보이도록 (1/5 = 0.2)
    );
    
    // 페이지 변화 리스너 추가
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // 초기 중앙 카드 선택
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.characters.isNotEmpty) {
        final initialCharacter = widget.characters[_currentIndex];
        _selectCharacter(initialCharacter);
      }
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(() {});
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onPageChanged(int virtualIndex) {
    final realIndex = virtualIndex % widget.characters.length;
    setState(() {
      _currentIndex = realIndex;
    });
    
    // 중앙 카드를 자동으로 선택
    final centerCharacter = widget.characters[realIndex];
    _selectCharacter(centerCharacter);
  }
  
  // 중앙에서의 거리를 계산하여 스케일 반환
  double _getScale(int virtualIndex) {
    final distance = (virtualIndex - _currentPage).abs();
    
    // 부드러운 스케일 전환을 위한 Ease Out Cubic 곡선 적용
    if (distance <= 0.5) {
      // 중앙에 매우 가까운 카드
      return 1.0 - (distance * 0.2);
    } else if (distance <= 1.0) {
      // 중앙 카드와 인접 카드 사이
      final t = (distance - 0.5) * 2;
      return 0.9 - (t * 0.1);
    } else if (distance <= 2.0) {
      // 1-2번째 거리의 카드
      final t = distance - 1.0;
      return 0.8 - (t * 0.1);
    } else if (distance <= 3.0) {
      // 2-3번째 거리의 카드
      final t = distance - 2.0;
      return 0.7 - (t * 0.05);
    } else {
      // 나머지 카드들
      return 0.65;
    }
  }
  
  // 중앙에서의 거리를 계산하여 투명도 반환
  double _getOpacity(int virtualIndex) {
    final distance = (virtualIndex - _currentPage).abs();
    
    if (distance <= 0.5) {
      return 1.0;
    } else if (distance <= 1.0) {
      return 0.95 - ((distance - 0.5) * 0.1);
    } else if (distance <= 2.0) {
      return 0.85 - ((distance - 1.0) * 0.15);
    } else if (distance <= 3.0) {
      return 0.7 - ((distance - 2.0) * 0.1);
    } else {
      return 0.6;
    }
  }

  void _selectCharacter(BiblicalCharacter character) {
    // 선택된 캐릭터를 상태에 저장
    ref.read(selectedCharacterProvider.notifier).selectCharacter(character);
    
    // 콜백 실행
    widget.onCharacterSelected(character);
    
    // 선택 피드백 애니메이션
    _slideController.forward().then((_) {
      _slideController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    
    return SizedBox(
      height: 520, // 카드 높이 + 호버 확대 여유 공간
      child: Column(
        children: [
          // 캐러셀과 화살표 버튼
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 480, // 420 * 1.05 (호버 스케일) + 여유 공간
                child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                // macOS에서 드래그 제스처 처리
                _pageController.position.moveTo(
                  _pageController.position.pixels - details.delta.dx,
                );
              },
              onHorizontalDragEnd: (details) {
                // 드래그 종료 시 페이지 스냅
                final velocity = details.velocity.pixelsPerSecond.dx;
                if (velocity.abs() > 300) {
                  // 빠른 스와이프
                  if (velocity > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                    );
                  }
                } else {
                  // 느린 드래그 - 가장 가까운 페이지로 스냅
                  final page = _pageController.page?.round() ?? _initialPage;
                  _pageController.animateToPage(
                    page,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                pageSnapping: true,
                physics: const AlwaysScrollableScrollPhysics(), // macOS 호환성을 위해 변경
                itemCount: _virtualListSize, // 무한 스크롤을 위한 큰 수
                itemBuilder: (context, virtualIndex) {
                // 실제 캐릭터 인덱스로 변환
                final realIndex = virtualIndex % widget.characters.length;
                final character = widget.characters[realIndex];
                final isCenter = realIndex == _currentIndex;
                final isSelected = selectedCharacter?.id == character.id;
                
                // 스케일링 및 투명도 계산
                final scale = _getScale(virtualIndex);
                final opacity = _getOpacity(virtualIndex);
                
                return AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    return Center(
                      child: AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Transform.translate(
                          offset: Offset(
                            isSelected ? _slideController.value * 10 - 5 : 0,
                            0,
                          ),
                          child: CharacterCarouselCard(
                            character: character,
                            isSelected: isSelected,
                            isCenter: isCenter,
                            onTap: isCenter ? () => _selectCharacter(character) : null,
                            opacity: opacity,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ),
          ),
              
              // 왼쪽 화살표 버튼
              Positioned(
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      );
                    },
                  ),
                ),
              ),
              
              // 오른쪽 화살표 버튼
              Positioned(
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 페이지 인디케이터 - 16개 인디케이터 모두 표시하되 현재 선택된 것만 강조
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              widget.characters.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: index == _currentIndex ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}