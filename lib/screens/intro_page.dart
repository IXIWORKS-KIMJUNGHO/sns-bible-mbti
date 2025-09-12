import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/circular_liquid_glass_widget.dart';

/// Demo page showing circular liquid glass widget implementation
/// Optimized for iPad 13-inch landscape mode (2064x1536)
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: IntroLiquidGlassWidget(
            title: 'Biblical MBTI',
            description: 'Discover your personality through biblical characters and stories. '
                'Explore how your unique traits connect with timeless wisdom.',
            onStartPressed: () {
              // Navigate to main app
              Navigator.pushReplacementNamed(context, '/main');
            },
            startButtonText: '시작하기',
          ),
        ),
      ),
    );
  }
}

/// Alternative demo showing custom implementation
class CustomIntroPage extends StatelessWidget {
  const CustomIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.3, -0.7),
            radius: 1.5,
            colors: [
              Colors.purple.shade300,
              Colors.blue.shade600,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Center(
          child: CircularLiquidGlassWidget(
            opacity: 0.2,
            borderOpacity: 0.4,
            blurRadius: 25.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'Biblical MBTI',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Personality Through Scripture',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Discover your biblical character match',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 임시: 결과 화면 바로가기 버튼
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // 테스트용 데이터 설정
                      context.go('/result');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      '🚀 결과 화면 바로가기 (테스트)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Show info
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('더 알아보기'),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          '시작하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtle glass effect demo
class SubtleIntroPage extends StatelessWidget {
  const SubtleIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF74b9ff),
              Color(0xFF0984e3),
              Color(0xFF2d3436),
            ],
          ),
        ),
        child: Center(
          child: SubtleLiquidGlassWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Biblical Wisdom\nMeets Modern Psychology',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Explore your personality through the lens of biblical characters and discover how ancient wisdom applies to modern life.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      foregroundColor: const Color(0xFF2d3436),
                      elevation: 12,
                      shadowColor: Colors.black.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Begin Journey',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Vibrant glass effect demo
class VibrantIntroPage extends StatelessWidget {
  const VibrantIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFff9a9e),
              Color(0xFFfecfef),
              Color(0xFFfecfef),
              Color(0xFFfad0c4),
            ],
          ),
        ),
        child: Center(
          child: VibrantLiquidGlassWidget(
            accentColor: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'Biblical MBTI',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 4.0,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  '성경 인물로 알아보는 나의 성격',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 12,
                      shadowColor: Colors.black.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      '성격 테스트 시작하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}