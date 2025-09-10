import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결과'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/assessment'),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 80,
              color: Colors.amber,
            ),
            SizedBox(height: 16),
            Text(
              '결과 비교 화면',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('목표 인물과 현재 나의 비교 결과'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        label: const Text('다시 하기'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}