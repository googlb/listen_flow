// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listening_material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListeningMaterial {

 String get id; String get title; String get description; String get imageUrl; String get audioUrl; List<TranscriptSegment> get transcript;
/// Create a copy of ListeningMaterial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningMaterialCopyWith<ListeningMaterial> get copyWith => _$ListeningMaterialCopyWithImpl<ListeningMaterial>(this as ListeningMaterial, _$identity);

  /// Serializes this ListeningMaterial to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&const DeepCollectionEquality().equals(other.transcript, transcript));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imageUrl,audioUrl,const DeepCollectionEquality().hash(transcript));

@override
String toString() {
  return 'ListeningMaterial(id: $id, title: $title, description: $description, imageUrl: $imageUrl, audioUrl: $audioUrl, transcript: $transcript)';
}


}

/// @nodoc
abstract mixin class $ListeningMaterialCopyWith<$Res>  {
  factory $ListeningMaterialCopyWith(ListeningMaterial value, $Res Function(ListeningMaterial) _then) = _$ListeningMaterialCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String imageUrl, String audioUrl, List<TranscriptSegment> transcript
});




}
/// @nodoc
class _$ListeningMaterialCopyWithImpl<$Res>
    implements $ListeningMaterialCopyWith<$Res> {
  _$ListeningMaterialCopyWithImpl(this._self, this._then);

  final ListeningMaterial _self;
  final $Res Function(ListeningMaterial) _then;

/// Create a copy of ListeningMaterial
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrl = null,Object? audioUrl = null,Object? transcript = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ListeningMaterial implements ListeningMaterial {
   _ListeningMaterial({required this.id, required this.title, required this.description, required this.imageUrl, required this.audioUrl, required final  List<TranscriptSegment> transcript}): _transcript = transcript;
  factory _ListeningMaterial.fromJson(Map<String, dynamic> json) => _$ListeningMaterialFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String imageUrl;
@override final  String audioUrl;
 final  List<TranscriptSegment> _transcript;
@override List<TranscriptSegment> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}


/// Create a copy of ListeningMaterial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListeningMaterialCopyWith<_ListeningMaterial> get copyWith => __$ListeningMaterialCopyWithImpl<_ListeningMaterial>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListeningMaterialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListeningMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&const DeepCollectionEquality().equals(other._transcript, _transcript));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imageUrl,audioUrl,const DeepCollectionEquality().hash(_transcript));

@override
String toString() {
  return 'ListeningMaterial(id: $id, title: $title, description: $description, imageUrl: $imageUrl, audioUrl: $audioUrl, transcript: $transcript)';
}


}

/// @nodoc
abstract mixin class _$ListeningMaterialCopyWith<$Res> implements $ListeningMaterialCopyWith<$Res> {
  factory _$ListeningMaterialCopyWith(_ListeningMaterial value, $Res Function(_ListeningMaterial) _then) = __$ListeningMaterialCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String imageUrl, String audioUrl, List<TranscriptSegment> transcript
});




}
/// @nodoc
class __$ListeningMaterialCopyWithImpl<$Res>
    implements _$ListeningMaterialCopyWith<$Res> {
  __$ListeningMaterialCopyWithImpl(this._self, this._then);

  final _ListeningMaterial _self;
  final $Res Function(_ListeningMaterial) _then;

/// Create a copy of ListeningMaterial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrl = null,Object? audioUrl = null,Object? transcript = null,}) {
  return _then(_ListeningMaterial(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,
  ));
}


}

// dart format on
