// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) =>
    QuestionOption(
      text: json['text'] as String,
      scores: Map<String, int>.from(json['scores'] as Map),
    );

Map<String, dynamic> _$QuestionOptionToJson(QuestionOption instance) =>
    <String, dynamic>{'text': instance.text, 'scores': instance.scores};
