// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListeningMaterial _$ListeningMaterialFromJson(Map<String, dynamic> json) =>
    _ListeningMaterial(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      transcript:
          (json['transcript'] as List<dynamic>)
              .map((e) => TranscriptSegment.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ListeningMaterialToJson(_ListeningMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'transcript': instance.transcript,
    };
