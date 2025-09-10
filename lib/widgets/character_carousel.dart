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
  }

  @override
  void dispose() {
    _pageController.removeListener(() {});
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onPageChanged(int virtualIndex) {
    setState(() {
      _currentIndex = virtualIndex % widget.characters.length;
    });
  }
  
  // 중앙에서의 거리를 계산하여 스케일 반환
  double _getScale(int virtualIndex) {
    final distance = (virtualIndex - _currentPage).abs();
    if (distance <= 1.0) {
      // 중앙 카드는 1.0, 인접 카드는 0.85로 선형 변화
      return 1.0 - (distance * 0.15);
    } else if (distance <= 2.0) {
      // 2번째 인접 카드는 0.7로 선형 변화
      return 0.85 - ((distance - 1.0) * 0.15);
    } else {
      // 나머지 카드는 0.6
      return 0.6;
    }
  }
  
  // 중앙에서의 거리를 계산하여 투명도 반환
  double _getOpacity(int virtualIndex) {
    final distance = (virtualIndex - _currentPage).abs();
    if (distance <= 1.0) {
      return 1.0 - (distance * 0.1);
    } else if (distance <= 2.0) {
      return 0.9 - ((distance - 1.0) * 0.2);
    } else {
      return 0.5;
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
      height: 460, // 카드 높이 + 여백
      child: Column(
        children: [
          // 캐러셀
          SizedBox(
            height: 420,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
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
                      child: Transform.scale(
                        scale: scale,
                        child: Transform.translate(
                          offset: Offset(
                            isSelected ? _slideController.value * 10 - 5 : 0,
                            0,
                          ),
                          child: CharacterCarouselCard(
                            character: character,
                            isSelected: isSelected,
                            isCenter: isCenter,
                            onTap: () => _selectCharacter(character),
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