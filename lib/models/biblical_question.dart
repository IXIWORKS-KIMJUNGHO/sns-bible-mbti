import 'dart:convert';
import 'package:flutter/services.dart';

class BiblicalQuestion {
  final int id;
  final String text;
  final List<QuestionOption> options;

  BiblicalQuestion({
    required this.id,
    required this.text,
    required this.options,
  });

  factory BiblicalQuestion.fromJson(Map<String, dynamic> json) {
    return BiblicalQuestion(
      id: json['id'],
      text: json['text'],
      options: (json['options'] as List)
          .map((option) => QuestionOption.fromJson(option))
          .toList(),
    );
  }
}

class QuestionOption {
  final String text;
  final Map<String, int> scores;

  QuestionOption({
    required this.text,
    required this.scores,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      text: json['text'],
      scores: Map<String, int>.from(json['scores'] ?? {}),
    );
  }
}

class QuestionsLoader {
  static Future<List<BiblicalQuestion>> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/biblical_questions.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData
          .map((question) => BiblicalQuestion.fromJson(question))
          .toList();
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }
}