// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerScreenState implements DiagnosticableTreeMixin {

 PlayerState get playerState;/// The current playback position.
 Duration get currentPosition;/// The position up to which the audio is buffered.
 Duration get bufferedPosition;/// The total duration of the loaded audio track.
 Duration get totalDuration;/// The index of the currently highlighted transcript segment. -1 means none.
 int get currentSegmentIndex;/// The current playback speed multiplier.
 double get playbackSpeed;/// Flag indicating if the player is initially loading a new audio source.
 bool get isLoading;/// Holds an error message if something went wrong in the player. Null if no error.
 String? get errorMessage;
/// Create a copy of PlayerScreenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerScreenStateCopyWith<PlayerScreenState> get copyWith => _$PlayerScreenStateCopyWithImpl<PlayerScreenState>(this as PlayerScreenState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PlayerScreenState'))
    ..add(DiagnosticsProperty('playerState', playerState))..add(DiagnosticsProperty('currentPosition', currentPosition))..add(DiagnosticsProperty('bufferedPosition', bufferedPosition))..add(DiagnosticsProperty('totalDuration', totalDuration))..add(DiagnosticsProperty('currentSegmentIndex', currentSegmentIndex))..add(DiagnosticsProperty('playbackSpeed', playbackSpeed))..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerScreenState&&(identical(other.playerState, playerState) || other.playerState == playerState)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.currentSegmentIndex, currentSegmentIndex) || other.currentSegmentIndex == currentSegmentIndex)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,playerState,currentPosition,bufferedPosition,totalDuration,currentSegmentIndex,playbackSpeed,isLoading,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PlayerScreenState(playerState: $playerState, currentPosition: $currentPosition, bufferedPosition: $bufferedPosition, totalDuration: $totalDuration, currentSegmentIndex: $currentSegmentIndex, playbackSpeed: $playbackSpeed, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PlayerScreenStateCopyWith<$Res>  {
  factory $PlayerScreenStateCopyWith(PlayerScreenState value, $Res Function(PlayerScreenState) _then) = _$PlayerScreenStateCopyWithImpl;
@useResult
$Res call({
 PlayerState playerState, Duration currentPosition, Duration bufferedPosition, Duration totalDuration, int currentSegmentIndex, double playbackSpeed, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$PlayerScreenStateCopyWithImpl<$Res>
    implements $PlayerScreenStateCopyWith<$Res> {
  _$PlayerScreenStateCopyWithImpl(this._self, this._then);

  final PlayerScreenState _self;
  final $Res Function(PlayerScreenState) _then;

/// Create a copy of PlayerScreenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerState = null,Object? currentPosition = null,Object? bufferedPosition = null,Object? totalDuration = null,Object? currentSegmentIndex = null,Object? playbackSpeed = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
playerState: null == playerState ? _self.playerState : playerState // ignore: cast_nullable_to_non_nullable
as PlayerState,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,currentSegmentIndex: null == currentSegmentIndex ? _self.currentSegmentIndex : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _PlayerScreenState with DiagnosticableTreeMixin implements PlayerScreenState {
  const _PlayerScreenState({required this.playerState, this.currentPosition = Duration.zero, this.bufferedPosition = Duration.zero, this.totalDuration = Duration.zero, this.currentSegmentIndex = -1, this.playbackSpeed = 1.0, this.isLoading = false, this.errorMessage = null});
  

@override final  PlayerState playerState;
/// The current playback position.
@override@JsonKey() final  Duration currentPosition;
/// The position up to which the audio is buffered.
@override@JsonKey() final  Duration bufferedPosition;
/// The total duration of the loaded audio track.
@override@JsonKey() final  Duration totalDuration;
/// The index of the currently highlighted transcript segment. -1 means none.
@override@JsonKey() final  int currentSegmentIndex;
/// The current playback speed multiplier.
@override@JsonKey() final  double playbackSpeed;
/// Flag indicating if the player is initially loading a new audio source.
@override@JsonKey() final  bool isLoading;
/// Holds an error message if something went wrong in the player. Null if no error.
@override@JsonKey() final  String? errorMessage;

/// Create a copy of PlayerScreenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerScreenStateCopyWith<_PlayerScreenState> get copyWith => __$PlayerScreenStateCopyWithImpl<_PlayerScreenState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PlayerScreenState'))
    ..add(DiagnosticsProperty('playerState', playerState))..add(DiagnosticsProperty('currentPosition', currentPosition))..add(DiagnosticsProperty('bufferedPosition', bufferedPosition))..add(DiagnosticsProperty('totalDuration', totalDuration))..add(DiagnosticsProperty('currentSegmentIndex', currentSegmentIndex))..add(DiagnosticsProperty('playbackSpeed', playbackSpeed))..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerScreenState&&(identical(other.playerState, playerState) || other.playerState == playerState)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.currentSegmentIndex, currentSegmentIndex) || other.currentSegmentIndex == currentSegmentIndex)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,playerState,currentPosition,bufferedPosition,totalDuration,currentSegmentIndex,playbackSpeed,isLoading,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PlayerScreenState(playerState: $playerState, currentPosition: $currentPosition, bufferedPosition: $bufferedPosition, totalDuration: $totalDuration, currentSegmentIndex: $currentSegmentIndex, playbackSpeed: $playbackSpeed, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PlayerScreenStateCopyWith<$Res> implements $PlayerScreenStateCopyWith<$Res> {
  factory _$PlayerScreenStateCopyWith(_PlayerScreenState value, $Res Function(_PlayerScreenState) _then) = __$PlayerScreenStateCopyWithImpl;
@override @useResult
$Res call({
 PlayerState playerState, Duration currentPosition, Duration bufferedPosition, Duration totalDuration, int currentSegmentIndex, double playbackSpeed, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$PlayerScreenStateCopyWithImpl<$Res>
    implements _$PlayerScreenStateCopyWith<$Res> {
  __$PlayerScreenStateCopyWithImpl(this._self, this._then);

  final _PlayerScreenState _self;
  final $Res Function(_PlayerScreenState) _then;

/// Create a copy of PlayerScreenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerState = null,Object? currentPosition = null,Object? bufferedPosition = null,Object? totalDuration = null,Object? currentSegmentIndex = null,Object? playbackSpeed = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_PlayerScreenState(
playerState: null == playerState ? _self.playerState : playerState // ignore: cast_nullable_to_non_nullable
as PlayerState,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,currentSegmentIndex: null == currentSegmentIndex ? _self.currentSegmentIndex : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
