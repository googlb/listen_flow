// import 'package:flutter/foundation.dart'; // Recommended import for better devtools logging
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:just_audio/just_audio.dart'; // Import PlayerState from just_audio

// part 'player_state.freezed.dart'; // Link to generated freezed file
// part 'player_state.g.dart';

// /// Represents the UI state for the player screen/feature using Freezed.
// @freezed
// abstract class PlayerScreenState with _$PlayerScreenState {
//   /// Private constructor. Allows adding custom methods/getters later.
//   const PlayerScreenState._();

//   /// Factory constructor defining the main state structure and default values.
//   /// Corresponds to the main example in the Freezed documentation.
//    factory PlayerScreenState({
//     /// The current state details from the underlying `just_audio` player.
//     // required PlayerState playerState,

//     /// The current playback position.
//     @Default(Duration.zero) Duration currentPosition,

//     /// The position up to which the audio is buffered.
//     @Default(Duration.zero) Duration bufferedPosition,

//     /// The total duration of the loaded audio track.
//     @Default(Duration.zero) Duration totalDuration,

//     /// The index of the currently highlighted transcript segment. -1 means none.
//     @Default(-1) int currentSegmentIndex,

//     /// The current playback speed multiplier.
//     @Default(1.0) double playbackSpeed,

//     /// Flag indicating if the player is initially loading a new audio source.
//     @Default(false) bool isLoading,

//     /// Holds an error message if something went wrong in the player. Null if no error.
//     @Default(null) String? errorMessage,
    
//   }) = _PlayerScreenState; // Links to the generated implementation class

//   factory PlayerScreenState.initial() => PlayerScreenState(
//         // Initialize with just_audio's default idle state
//         playerState: PlayerState(false, ProcessingState.idle),
//         // Other fields automatically get their @Default values
//       );


// }


