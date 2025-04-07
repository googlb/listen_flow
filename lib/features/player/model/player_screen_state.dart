import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

part 'player_screen_state.freezed.dart';
// part 'player_screen_state.g.dart';

@freezed
abstract class PlayerScreenState with _$PlayerScreenState {
  const factory PlayerScreenState({
    required PlayerState playerState,

    /// The current playback position.
    @Default(Duration.zero) Duration currentPosition,

    /// The position up to which the audio is buffered.
    @Default(Duration.zero) Duration bufferedPosition,

    /// The total duration of the loaded audio track.
    @Default(Duration.zero) Duration totalDuration,

    /// The index of the currently highlighted transcript segment. -1 means none.
    @Default(-1) int currentSegmentIndex,

    /// The current playback speed multiplier.
    @Default(1.0) double playbackSpeed,

    /// Flag indicating if the player is initially loading a new audio source.
    @Default(false) bool isLoading,

    /// Holds an error message if something went wrong in the player. Null if no error.
    @Default(null) String? errorMessage,
  }) = _PlayerScreenState;

    factory PlayerScreenState.initial() => PlayerScreenState(
        // Initialize with just_audio's default idle state
        playerState: PlayerState(false, ProcessingState.idle),
        // Other fields automatically get their @Default values
      );

}
