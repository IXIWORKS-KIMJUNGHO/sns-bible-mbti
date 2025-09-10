// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentResult _$AssessmentResultFromJson(Map<String, dynamic> json) =>
    AssessmentResult(
      targetCharacter: BiblicalCharacter.fromJson(
        json['targetCharacter'] as Map<String, dynamic>,
      ),
      resultCharacter: BiblicalCharacter.fromJson(
        json['resultCharacter'] as Map<String, dynamic>,
      ),
      answerChoices: Map<String, int>.from(json['answerChoices'] as Map),
      similarityScore: (json['similarityScore'] as num).toDouble(),
      strengthsToMaintain: (json['strengthsToMaintain'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      growthPoints: (json['growthPoints'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$AssessmentResultToJson(AssessmentResult instance) =>
    <String, dynamic>{
      'targetCharacter': instance.targetCharacter,
      'resultCharacter': instance.resultCharacter,
      'answerChoices': instance.answerChoices,
      'similarityScore': instance.similarityScore,
      'strengthsToMaintain': instance.strengthsToMaintain,
      'growthPoints': instance.growthPoints,
      'completedAt': instance.completedAt.toIso8601String(),
    };
