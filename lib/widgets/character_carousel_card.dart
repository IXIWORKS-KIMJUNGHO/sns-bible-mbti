import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/biblical_character.dart';

/// 성경인물 선택용 글래스모피즘 카드 위젯
///
/// iPad 13인치 가로모드에 최적화된 캐러셀 카드
class CharacterCarouselCard extends StatefulWidget {
  final BiblicalCharacter character;
  final bool isSelected;
  final bool isCenter;
  final VoidCallback? onTap;
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
  VideoPlayerController? _videoController;
  bool _isHovered = false;

  // 비디오 파일 매핑 (파일명 오타 처리 포함)
  String _getVideoPath(String characterId) {
    final Map<String, String> videoMapping = {
      'david': 'David.mp4',
      'esther': 'Esther.mp4',
      'moses': 'Moses.mp4', // 파일명 오타
      'mary': 'Mary.mp4',
      'joseph': 'Joseph.mp4', // 파일명 오타
      'paul': 'Paul.mp4',
      'daniel': 'Daniel.mp4',
      'solomon': 'Solomon.mp4',
      'deborah': 'Deborah.mp4',
      'barnabas': 'Barnabas.mp4',
      'luke': 'Luke.mp4',
      'jeremiah': 'Jeremiah.mp4', // 파일명 오타
      'noah': 'Noah.mp4',
      'rebekah': 'Rebekah.mp4',
      'prodigal_son': 'ProdigalSon.mp4', // 파일명 오타
      'peter': 'Peter.mp4',
    };

    final fileName = videoMapping[characterId];
    if (fileName != null) {
      return 'assets/videos/bible_people/$fileName';
    }
    return '';
  }

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
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    // 비디오 컨트롤러 초기화
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoPath = _getVideoPath(widget.character.id);

    if (videoPath.isNotEmpty) {
      _videoController = VideoPlayerController.asset(videoPath)
        ..initialize()
            .then((_) {
              if (mounted) {
                setState(() {});
                // 루프 설정
                _videoController?.setLooping(true);
                _videoController?.setVolume(0); // 음소거
                // 중앙에 있는 카드만 재생
                if (widget.isCenter) {
                  _videoController?.play();
                }
              }
            })
            .catchError((error) {
              // 에러 처리
            });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CharacterCarouselCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.character.id != widget.character.id) {
      // 캐릭터가 변경되면 비디오 재초기화
      _videoController?.dispose();
      _initializeVideo();
    } else if (oldWidget.isCenter != widget.isCenter) {
      // 중앙 위치가 변경되면 재생/정지 상태 업데이트
      if (widget.isCenter) {
        _videoController?.play();
      } else {
        _videoController?.pause();
      }
    }
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

  @override
  Widget build(BuildContext context) {
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
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20), // 위아래 여백 추가
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
                                ? Colors.white.withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.3),
                            width: widget.isSelected ? 3.0 : 2.0,
                          ),
                          boxShadow: [
                            if (widget.isSelected || _isHovered)
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.2),
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
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.black.withValues(alpha: 0.8),
                                    size: 16,
                                  ),
                                ),

                              // 캐릭터 비디오 또는 이미지 플레이스홀더
                              Container(
                                width: 160,
                                height: 160,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child:
                                      _videoController != null &&
                                          _videoController!.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio: 1.0,
                                          child: VideoPlayer(_videoController!),
                                        )
                                      : Icon(
                                          Icons.person_outline,
                                          size: 80,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                ),
                              ),

                              // 캐릭터 이름
                              Text(
                                widget.character.name,
                                style: const TextStyle(
                                  fontFamily: 'SpoqaHanSansNeo',
                                  fontSize: 21,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
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

                              // 캐릭터 설명 - 더 많은 공간 할당
                              Expanded(
                                flex: 4, // 더 많은 공간 할당
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
                                ),
                              ),

                              const SizedBox(height: 16), // 키워드와 설명 사이 여백
                              // 특성 태그들 - 카드 맨 하단 고정
                              SizedBox(
                                height: 13, // 고정 높이
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  alignment: WrapAlignment.center,
                                  children: widget.character.traits.take(3).map(
                                    (trait) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.15,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
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
                                    },
                                  ).toList(),
                                ),
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
