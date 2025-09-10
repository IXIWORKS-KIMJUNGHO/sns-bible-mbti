import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MBTI 테스트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/character-selection'),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '카드 스와이프 테스트 화면',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('22개 질문에 답해주세요'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/result'),
        label: const Text('결과 보기'),
        icon: const Icon(Icons.assessment),
      ),
    );
  }
}