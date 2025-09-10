// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biblical_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BiblicalCharacter _$BiblicalCharacterFromJson(Map<String, dynamic> json) =>
    BiblicalCharacter(
      id: json['id'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      mainEvents: (json['mainEvents'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      behaviorPatterns: (json['behaviorPatterns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageAsset: json['imageAsset'] as String,
      traits: (json['traits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bibleVerse: json['bibleVerse'] as String,
      verseReference: json['verseReference'] as String,
      colorTheme: json['colorTheme'] as String,
    );

Map<String, dynamic> _$BiblicalCharacterToJson(BiblicalCharacter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'englishName': instance.englishName,
      'title': instance.title,
      'description': instance.description,
      'mainEvents': instance.mainEvents,
      'behaviorPatterns': instance.behaviorPatterns,
      'imageAsset': instance.imageAsset,
      'traits': instance.traits,
      'bibleVerse': instance.bibleVerse,
      'verseReference': instance.verseReference,
      'colorTheme': instance.colorTheme,
    };
