import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/biblical_character.dart';

/// 성경인물 선택용 글래스모피즘 카드 위젯
/// 
/// iPad 13인치 가로모드에 최적화된 캐러셀 카드
class CharacterCarouselCard extends StatefulWidget {
  final BiblicalCharacter character;
  final bool isSelected;
  final bool isCenter;
  final VoidCallback onTap;
  final double opacity;

  const CharacterCarouselCard({
    super.key,
    required this.character,
    required this.isSelected,
    required this.isCenter,
    required this.onTap,
    this.opacity = 1.0,
  });

  @override
  State<CharacterCarouselCard> createState() => _CharacterCarouselCardState();
}

class _CharacterCarouselCardState extends State<CharacterCarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  Color _getThemeColor() {
    switch (widget.character.colorTheme) {
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'amber':
        return Colors.amber;
      case 'teal':
        return Colors.teal;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'indigo':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();
    final cardOpacity = widget.isCenter ? 1.0 : 0.7;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: cardOpacity * widget.opacity,
                child: Container(
                  width: 280,
                  height: 420,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: widget.isSelected 
                                ? themeColor.withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.3),
                            width: widget.isSelected ? 3.0 : 2.0,
                          ),
                          boxShadow: [
                            if (widget.isSelected || _isHovered)
                              BoxShadow(
                                color: themeColor.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // 선택 표시기
                              if (widget.isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              
                              // 캐릭터 이미지 플레이스홀더
                              Container(
                                width: 120,
                                height: 120,
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeColor.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: themeColor.withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 60,
                                  color: themeColor,
                                ),
                              ),
                              
                              // 캐릭터 이름
                              Text(
                                widget.character.name,
                                style: const TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 4.0,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // 캐릭터 타이틀
                              Text(
                                widget.character.title,
                                style: TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: themeColor.withValues(alpha: 0.9),
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
                              
                              const SizedBox(height: 12),
                              
                              // 캐릭터 설명
                              Expanded(
                                child: Text(
                                  widget.character.description,
                                  style: const TextStyle(
                                    fontFamily: 'SpoqaHanSansNeo',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    height: 1.5,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0.5, 0.5),
                                        blurRadius: 2.0,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // 특성 태그들
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                alignment: WrapAlignment.center,
                                children: widget.character.traits.take(3).map((trait) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeColor.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: themeColor.withValues(alpha: 0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      trait,
                                      style: const TextStyle(
                                        fontFamily: 'SpoqaHanSansNeo',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
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
    );
  }
}