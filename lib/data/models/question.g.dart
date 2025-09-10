// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'options': instance.options,
};
