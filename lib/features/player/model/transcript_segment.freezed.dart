// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript_segment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscriptSegment {

 String get englishText; String get chineseText;@DurationConverter() Duration get startTime;@DurationConverter() Duration get endTime;
/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptSegmentCopyWith<TranscriptSegment> get copyWith => _$TranscriptSegmentCopyWithImpl<TranscriptSegment>(this as TranscriptSegment, _$identity);

  /// Serializes this TranscriptSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptSegment&&(identical(other.englishText, englishText) || other.englishText == englishText)&&(identical(other.chineseText, chineseText) || other.chineseText == chineseText)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,englishText,chineseText,startTime,endTime);

@override
String toString() {
  return 'TranscriptSegment(englishText: $englishText, chineseText: $chineseText, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $TranscriptSegmentCopyWith<$Res>  {
  factory $TranscriptSegmentCopyWith(TranscriptSegment value, $Res Function(TranscriptSegment) _then) = _$TranscriptSegmentCopyWithImpl;
@useResult
$Res call({
 String englishText, String chineseText,@DurationConverter() Duration startTime,@DurationConverter() Duration endTime
});




}
/// @nodoc
class _$TranscriptSegmentCopyWithImpl<$Res>
    implements $TranscriptSegmentCopyWith<$Res> {
  _$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final TranscriptSegment _self;
  final $Res Function(TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? englishText = null,Object? chineseText = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
englishText: null == englishText ? _self.englishText : englishText // ignore: cast_nullable_to_non_nullable
as String,chineseText: null == chineseText ? _self.chineseText : chineseText // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as Duration,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TranscriptSegment implements TranscriptSegment {
   _TranscriptSegment({required this.englishText, required this.chineseText, @DurationConverter() required this.startTime, @DurationConverter() required this.endTime});
  factory _TranscriptSegment.fromJson(Map<String, dynamic> json) => _$TranscriptSegmentFromJson(json);

@override final  String englishText;
@override final  String chineseText;
@override@DurationConverter() final  Duration startTime;
@override@DurationConverter() final  Duration endTime;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptSegmentCopyWith<_TranscriptSegment> get copyWith => __$TranscriptSegmentCopyWithImpl<_TranscriptSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptSegment&&(identical(other.englishText, englishText) || other.englishText == englishText)&&(identical(other.chineseText, chineseText) || other.chineseText == chineseText)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,englishText,chineseText,startTime,endTime);

@override
String toString() {
  return 'TranscriptSegment(englishText: $englishText, chineseText: $chineseText, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$TranscriptSegmentCopyWith<$Res> implements $TranscriptSegmentCopyWith<$Res> {
  factory _$TranscriptSegmentCopyWith(_TranscriptSegment value, $Res Function(_TranscriptSegment) _then) = __$TranscriptSegmentCopyWithImpl;
@override @useResult
$Res call({
 String englishText, String chineseText,@DurationConverter() Duration startTime,@DurationConverter() Duration endTime
});




}
/// @nodoc
class __$TranscriptSegmentCopyWithImpl<$Res>
    implements _$TranscriptSegmentCopyWith<$Res> {
  __$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final _TranscriptSegment _self;
  final $Res Function(_TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? englishText = null,Object? chineseText = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_TranscriptSegment(
englishText: null == englishText ? _self.englishText : englishText // ignore: cast_nullable_to_non_nullable
as String,chineseText: null == chineseText ? _self.chineseText : chineseText // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as Duration,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
