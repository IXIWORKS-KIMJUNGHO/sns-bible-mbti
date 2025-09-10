import 'package:json_annotation/json_annotation.dart';
import 'question_option.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int id;
  final String text;
  final List<QuestionOption> options;

  const Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}