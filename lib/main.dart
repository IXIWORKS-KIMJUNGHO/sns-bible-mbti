import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/character_selection_screen.dart';
import 'presentation/screens/assessment_screen.dart';
import 'presentation/screens/result_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/character-selection',
      builder: (context, state) => const CharacterSelectionScreen(),
    ),
    GoRoute(
      path: '/assessment',
      builder: (context, state) => const AssessmentScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: BiblicalMbtiApp()));
}

class BiblicalMbtiApp extends StatelessWidget {
  const BiblicalMbtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '성경 인물 MBTI',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.notoSans().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
      ),
      routerConfig: _router,
    );
  }
}

