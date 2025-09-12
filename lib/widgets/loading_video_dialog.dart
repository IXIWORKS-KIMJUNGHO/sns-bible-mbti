import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoadingVideoDialog extends StatefulWidget {
  const LoadingVideoDialog({super.key});

  @override
  State<LoadingVideoDialog> createState() => _LoadingVideoDialogState();

  /// 로딩 다이얼로그 표시 헬퍼 메서드
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      builder: (context) => const LoadingVideoDialog(),
    );
  }
}

class _LoadingVideoDialogState extends State<LoadingVideoDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset('assets/videos/loading.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.setVolume(0); // 음소거
          _controller.play();
        }
      }).catchError((error) {
        debugPrint('Error loading video: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 뒤로가기 방지
      child: Material(
        color: Colors.black,
        child: Center(
          child: _isInitialized
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 비디오 플레이어
                    Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // 로딩 텍스트
                    Text(
                      '말씀카드를 준비하고 있습니다...',
                      style: TextStyle(
                        fontFamily: 'SpoqaHanSansNeo',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 서브 텍스트
                    Text(
                      '잠시만 기다려주세요',
                      style: TextStyle(
                        fontFamily: 'SpoqaHanSansNeo',
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 기본 로딩 인디케이터 (비디오 로딩 중)
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '준비 중...',
                      style: TextStyle(
                        fontFamily: 'SpoqaHanSansNeo',
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}