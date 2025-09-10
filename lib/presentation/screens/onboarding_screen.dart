import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/circular_liquid_glass_widget.dart';
import '../../widgets/video_background.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/videos/intro_video.mp4',
        child: Stack(
          children: [
            // Centered Circular Liquid Glass Widget
          Center(
            child: IntroLiquidGlassWidget(
              title: '성경 인물 매칭',
              description: '"믿음의 선택들을 통해\n나와 비슷한 성경 인물을 만나보세요"',
              onStartPressed: () {
                context.go('/character-selection');
              },
              startButtonText: '시작하기',
            ),
          ),
          ],
        ),
      ),
    );
  }
}