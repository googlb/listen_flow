import 'package:freezed_annotation/freezed_annotation.dart';

part "transcript_segment.freezed.dart";
part 'transcript_segment.g.dart';

@freezed
abstract class TranscriptSegment with _$TranscriptSegment {

  factory TranscriptSegment({
    required String englishText,
    required String chineseText,
    @DurationConverter() required Duration startTime,
    @DurationConverter() required Duration endTime,
  }) = _TranscriptSegment;

  factory TranscriptSegment.fromJson(Map<String, dynamic> json) => _$TranscriptSegmentFromJson(json);
}

class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();
  @override
  Duration fromJson(int json) => Duration(milliseconds: json);
  @override
  int toJson(Duration object) => object.inMilliseconds;
}