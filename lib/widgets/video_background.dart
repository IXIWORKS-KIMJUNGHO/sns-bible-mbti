import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 루프 재생되는 비디오 배경 위젯 (세로형에서는 이미지 배경)
class VideoBackground extends StatefulWidget {
  final String videoPath;
  final Widget? child;
  final BoxFit fit;
  final bool isPortrait;

  const VideoBackground({
    super.key,
    required this.videoPath,
    this.child,
    this.fit = BoxFit.cover,
    this.isPortrait = false,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 세로형이 아닐 때만 비디오 초기화
    if (!widget.isPortrait) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // 루프 재생 설정
        _controller.setLooping(true);
        _controller.play();
      }
    } catch (e) {
      debugPrint('비디오 초기화 실패: $e');
      // 비디오 로딩 실패 시 검은 배경으로 fallback
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (!widget.isPortrait) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 (세로형: 이미지, 가로형: 비디오)
        Positioned.fill(
          child: widget.isPortrait
              ? Image.asset(
                  'assets/images/vertical_bg.png',
                  fit: widget.fit,
                )
              : _isInitialized
                  ? FittedBox(
                      fit: widget.fit,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
        ),

        // 자식 위젯
        if (widget.child != null) widget.child!,
      ],
    );
  }
}