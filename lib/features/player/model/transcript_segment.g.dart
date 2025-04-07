// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranscriptSegment _$TranscriptSegmentFromJson(Map<String, dynamic> json) =>
    _TranscriptSegment(
      englishText: json['englishText'] as String,
      chineseText: json['chineseText'] as String,
      startTime: const DurationConverter().fromJson(
        (json['startTime'] as num).toInt(),
      ),
      endTime: const DurationConverter().fromJson(
        (json['endTime'] as num).toInt(),
      ),
    );

Map<String, dynamic> _$TranscriptSegmentToJson(_TranscriptSegment instance) =>
    <String, dynamic>{
      'englishText': instance.englishText,
      'chineseText': instance.chineseText,
      'startTime': const DurationConverter().toJson(instance.startTime),
      'endTime': const DurationConverter().toJson(instance.endTime),
    };
