import 'package:json_annotation/json_annotation.dart';

part 'question_option.g.dart';

@JsonSerializable()
class QuestionOption {
  final String text;
  final Map<String, int> scores; // 성경인물명: 점수

  const QuestionOption({
    required this.text,
    required this.scores,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionOptionToJson(this);
}