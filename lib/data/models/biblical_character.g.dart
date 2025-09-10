// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biblical_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BiblicalCharacter _$BiblicalCharacterFromJson(Map<String, dynamic> json) =>
    BiblicalCharacter(
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      description: json['description'] as String,
      mainEvents: (json['mainEvents'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      behaviorPatterns: (json['behaviorPatterns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      characteristics: (json['characteristics'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scriptureReferences: (json['scriptureReferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imagePath: json['imagePath'] as String,
      colorTheme: json['colorTheme'] as String,
      keyVerse: json['keyVerse'] as String,
      verseReference: json['verseReference'] as String,
    );

Map<String, dynamic> _$BiblicalCharacterToJson(BiblicalCharacter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'englishName': instance.englishName,
      'description': instance.description,
      'mainEvents': instance.mainEvents,
      'behaviorPatterns': instance.behaviorPatterns,
      'characteristics': instance.characteristics,
      'scriptureReferences': instance.scriptureReferences,
      'imagePath': instance.imagePath,
      'colorTheme': instance.colorTheme,
      'keyVerse': instance.keyVerse,
      'verseReference': instance.verseReference,
    };
