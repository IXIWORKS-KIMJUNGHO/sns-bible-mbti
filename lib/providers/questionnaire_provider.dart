import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/biblical_question.dart';

class QuestionnaireState {
  final List<BiblicalQuestion> questions;
  final int currentIndex;
  final Map<int, int> selectedAnswers; // questionIndex -> optionIndex
  final Map<String, int> characterScores; // characterId -> totalScore
  final Map<int, List<int>> shuffledIndices; // questionIndex -> shuffled order mapping

  QuestionnaireState({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.characterScores,
    required this.shuffledIndices,
  });

  QuestionnaireState copyWith({
    List<BiblicalQuestion>? questions,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    Map<String, int>? characterScores,
    Map<int, List<int>>? shuffledIndices,
  }) {
    return QuestionnaireState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      characterScores: characterScores ?? this.characterScores,
      shuffledIndices: shuffledIndices ?? this.shuffledIndices,
    );
  }
}

class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  final _random = Random();
  
  QuestionnaireNotifier()
      : super(QuestionnaireState(
          questions: [],
          currentIndex: 0,
          selectedAnswers: {},
          characterScores: {},
          shuffledIndices: {},
        )) {
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await QuestionsLoader.loadQuestions();
    
    // 각 질문에 대해 답변 옵션 순서를 셔플
    final shuffledIndices = <int, List<int>>{};
    for (int i = 0; i < questions.length; i++) {
      final optionCount = questions[i].options.length;
      final indices = List<int>.generate(optionCount, (index) => index);
      indices.shuffle(_random);
      shuffledIndices[i] = indices;
    }
    
    state = state.copyWith(
      questions: questions,
      shuffledIndices: shuffledIndices,
    );
  }
  
  // 셔플된 옵션 리스트를 반환하는 메서드
  List<QuestionOption> getShuffledOptions(int questionIndex) {
    if (questionIndex >= state.questions.length) return [];
    
    final question = state.questions[questionIndex];
    final shuffleOrder = state.shuffledIndices[questionIndex] ?? 
        List<int>.generate(question.options.length, (i) => i);
    
    return shuffleOrder.map((index) => question.options[index]).toList();
  }
  
  // 셔플된 인덱스를 원본 인덱스로 변환
  int getOriginalIndex(int questionIndex, int shuffledIndex) {
    final shuffleOrder = state.shuffledIndices[questionIndex];
    if (shuffleOrder == null || shuffledIndex >= shuffleOrder.length) {
      return shuffledIndex;
    }
    return shuffleOrder[shuffledIndex];
  }

  void selectAnswer(int shuffledOptionIndex) {
    // 셔플된 인덱스를 원본 인덱스로 변환
    final originalIndex = getOriginalIndex(state.currentIndex, shuffledOptionIndex);
    
    final newAnswers = Map<int, int>.from(state.selectedAnswers);
    newAnswers[state.currentIndex] = originalIndex;
    
    // 점수 재계산
    final newScores = _calculateScores(newAnswers);
    
    state = state.copyWith(
      selectedAnswers: newAnswers,
      characterScores: newScores,
    );
  }

  bool nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      return true;
    }
    return false;
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  Map<String, int> _calculateScores(Map<int, int> answers) {
    final scores = <String, int>{};
    
    answers.forEach((questionIndex, optionIndex) {
      if (questionIndex < state.questions.length) {
        final question = state.questions[questionIndex];
        if (optionIndex < question.options.length) {
          final option = question.options[optionIndex];
          option.scores.forEach((character, score) {
            scores[character] = (scores[character] ?? 0) + score;
          });
        }
      }
    });
    
    return scores;
  }

  Map<String, int> getFinalScores() {
    return state.characterScores;
  }

  String getTopCharacter() {
    if (state.characterScores.isEmpty) return '';
    
    var sortedScores = state.characterScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedScores.first.key;
  }
  
  List<MapEntry<String, int>> getTop3Characters() {
    if (state.characterScores.isEmpty) return [];
    
    var sortedScores = state.characterScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // 디버깅용 로그 출력
    print('===== 최종 점수 결과 =====');
    for (var entry in sortedScores) {
      print('${entry.key}: ${entry.value}점');
    }
    print('상위 1위: ${sortedScores.isNotEmpty ? sortedScores.first.key : "없음"}');
    print('=======================');
    
    return sortedScores.take(3).toList();
  }

  void reset() {
    // 리셋할 때 답변 옵션도 다시 셔플
    final shuffledIndices = <int, List<int>>{};
    for (int i = 0; i < state.questions.length; i++) {
      final optionCount = state.questions[i].options.length;
      final indices = List<int>.generate(optionCount, (index) => index);
      indices.shuffle(_random);
      shuffledIndices[i] = indices;
    }
    
    state = state.copyWith(
      currentIndex: 0,
      selectedAnswers: {},
      characterScores: {},
      shuffledIndices: shuffledIndices,
    );
  }
}

final questionnaireProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>((ref) {
  return QuestionnaireNotifier();
});