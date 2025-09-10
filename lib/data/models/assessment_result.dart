import 'package:json_annotation/json_annotation.dart';
import 'biblical_character.dart';

part 'assessment_result.g.dart';

@JsonSerializable()
class AssessmentResult {
  final BiblicalCharacter targetCharacter; // 목표로 선택한 인물
  final BiblicalCharacter resultCharacter; // 테스트 결과 인물
  final Map<String, int> answerChoices; // 질문ID: 선택한 옵션 인덱스
  final double similarityScore; // 목표와 결과 유사도 (0.0-1.0)
  final List<String> strengthsToMaintain; // 유지할 강점들
  final List<String> growthPoints; // 성장 포인트들
  final DateTime completedAt;

  const AssessmentResult({
    required this.targetCharacter,
    required this.resultCharacter,
    required this.answerChoices,
    required this.similarityScore,
    required this.strengthsToMaintain,
    required this.growthPoints,
    required this.completedAt,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) =>
      _$AssessmentResultFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentResultToJson(this);
}