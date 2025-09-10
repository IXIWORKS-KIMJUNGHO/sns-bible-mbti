import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 루프 재생되는 비디오 배경 위젯
class VideoBackground extends StatefulWidget {
  final String videoPath;
  final Widget? child;
  final BoxFit fit;

  const VideoBackground({
    super.key,
    required this.videoPath,
    this.child,
    this.fit = BoxFit.cover,
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
    _initializeVideo();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 비디오 배경
        Positioned.fill(
          child: _isInitialized
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