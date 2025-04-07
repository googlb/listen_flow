import 'dart:async'; // Required for StreamSubscription
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Base Riverpod (needed by generated code)
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/player_screen_state.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // Annotation package
import 'package:just_audio/just_audio.dart'; // The audio player library
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For transcript scrolling

// Import related models and state definition
import '../model/player_state.dart'; // The Freezed state class for the player UI

// Necessary part directive for the generator
part 'player_provider.g.dart';

/// Defines the Player Notifier using Riverpod code generation.
///
/// This manages the state ([PlayerScreenState]) and logic for the audio player,
/// interacting with `just_audio`, handling user actions, and syncing transcripts.
/// The `keepAlive` parameter determines if the state is preserved (`true`)
/// or disposed when unused (`false`, equivalent to autoDispose).
@riverpod // Default is keepAlive: false (autoDispose)
// Use @Riverpod(keepAlive: true) if you need the player state to persist globally
class Player extends _$Player { // Class name is 'Player', generated provider is 'playerProvider'

  /// The instance of the just_audio player. Kept private.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Holds the transcript data for the currently loaded material.
  List<TranscriptSegment> _transcript = [];

  // Stream subscriptions need to be stored so they can be cancelled on dispose.
  // Make them private for encapsulation.
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _bufferedPositionSubscription;

  /// Reference to the scroll controller for the transcript list. Injected from UI.
  /// Made private as it's set via a method.
  ItemScrollController? _itemScrollController;


  /// The build method is called when the provider is first read.
  /// It should return the initial state and can perform setup logic.
  @override
  PlayerScreenState build() {
    debugPrint("Player provider built. Initializing listener streams.");
    // Perform initialization logic that needs to happen once.
    _listenToPlayerStreams();

    // --- Setup Disposal Logic ---
    // Use ref.onDispose to register cleanup logic when the provider is disposed.
    ref.onDispose(() {
      debugPrint("Disposing Player provider...");
      // Cancel all active stream subscriptions to prevent memory leaks
      _playerStateSubscription?.cancel();
      _positionSubscription?.cancel();
      _durationSubscription?.cancel();
      _bufferedPositionSubscription?.cancel();
      // Release the audio player resources. Essential!
      _audioPlayer.dispose();
      debugPrint("Player provider disposed.");
    });

    // Return the initial state for the player.
    return PlayerScreenState.initial();
  }

  /// Allows the UI (e.g., DetailScreen, ReadingScreen) to provide the scroll controller.
  void setScrollController(ItemScrollController controller) {
    _itemScrollController = controller;
  }

  /// Sets up listeners for the various streams provided by the AudioPlayer. (Private helper)
  void _listenToPlayerStreams() {
    // Listen to changes in player state (playing, paused, completed, buffering, etc.)
    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      (playerState) {
        // Use the internal state getter 'state' provided by the generator
        _updateCurrentSegment(state.currentPosition);
        // Update the state using copyWith
        state = state.copyWith(
          playerState: playerState,
          currentSegmentIndex: (playerState.processingState == ProcessingState.completed ||
                                 playerState.processingState == ProcessingState.idle)
                              ? -1 : state.currentSegmentIndex,
        );
      },
    );

    // Listen to the current playback position
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      _updateCurrentSegment(position);
      state = state.copyWith(currentPosition: position);
    });

    // Listen for changes in the total duration of the audio
    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      state = state.copyWith(totalDuration: duration ?? Duration.zero);
    });

    // Listen for changes in the buffered position
    _bufferedPositionSubscription = _audioPlayer.bufferedPositionStream.listen((position) {
      state = state.copyWith(bufferedPosition: position);
    });
  }

  /// Loads a new audio material into the player. (Public method)
  Future<void> loadMaterial(ListeningMaterial material) async {
    if (material.audioUrl.isEmpty) {
      state = state.copyWith(isLoading: false, errorMessage: "Audio URL is missing.");
      debugPrint("PlayerNotifier: Error - Audio URL is empty for material ID ${material.id}");
      return;
    }
    debugPrint("PlayerNotifier: Loading material ID ${material.id} - URL: ${material.audioUrl}");
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      _transcript = material.transcript;
      await _audioPlayer.stop();
      // Reset state using the initial state from build(), keeping loading flag
      state = PlayerScreenState.initial().copyWith(isLoading: true);

      final effectiveDuration = await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(material.audioUrl)),
        preload: true,
      );
      debugPrint("PlayerNotifier: Material loaded. Effective duration: $effectiveDuration");
      state = state.copyWith(
        totalDuration: effectiveDuration ?? Duration.zero,
        isLoading: false,
        playbackSpeed: _audioPlayer.speed,
      );
    } on PlayerException catch (e) {
      debugPrint("PlayerNotifier: PlayerException loading audio: ${e.message} (Code: ${e.code})");
      state = state.copyWith(isLoading: false, errorMessage: "Error loading audio: ${e.message ?? 'Unknown player error'}");
    } on PlayerInterruptedException catch (e) {
       debugPrint("PlayerNotifier: PlayerInterruptedException loading audio: ${e.message}");
      state = state.copyWith(isLoading: false, errorMessage: "Audio playback interrupted.");
    } catch (e, stackTrace) {
      debugPrint("PlayerNotifier: Generic error loading audio: $e\n$stackTrace");
      state = state.copyWith(isLoading: false, errorMessage: "An unexpected error occurred while loading audio.");
    }
  }

  /// Calculates and updates the current transcript segment index. (Private helper)
  void _updateCurrentSegment(Duration position) {
      int newIndex = -1;
      if (_transcript.isEmpty || state.totalDuration <= Duration.zero) {
          if (state.currentSegmentIndex != -1) {
              state = state.copyWith(currentSegmentIndex: -1);
          }
           return;
       }

      for (int i = 0; i < _transcript.length; i++) {
        if (position >= _transcript[i].startTime &&
            position < (_transcript[i].endTime + const Duration(milliseconds: 100))) {
          newIndex = i;
          break;
        }
      }

     if (newIndex == -1 &&
         _transcript.isNotEmpty && // Ensure transcript is not empty before accessing last
         position >= _transcript.last.startTime &&
         position <= (state.totalDuration + const Duration(milliseconds: 200))) {
       newIndex = _transcript.length - 1;
     }

      if (newIndex != state.currentSegmentIndex) {
          state = state.copyWith(currentSegmentIndex: newIndex);
           if (newIndex != -1) {
               _scrollToIndex(newIndex);
           }
      }
  }

  /// Scrolls the transcript list to the specified index. (Private helper)
  void _scrollToIndex(int index) {
    if (_itemScrollController != null && _itemScrollController!.isAttached) {
      _itemScrollController!.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        alignment: 0.3,
      );
    }
  }

  // --- Public Methods for UI Interaction ---

  Future<void> play() async {
     if (!state.playerState.playing &&
         _audioPlayer.processingState != ProcessingState.loading &&
         _audioPlayer.processingState != ProcessingState.buffering) {
       try { await _audioPlayer.play(); }
       catch (e) {
         debugPrint("PlayerNotifier: Error calling play: $e");
         state = state.copyWith(errorMessage: "Could not start playback.");
       }
     }
  }

  Future<void> pause() async {
     if (state.playerState.playing) {
       try { await _audioPlayer.pause(); }
       catch (e) { debugPrint("PlayerNotifier: Error calling pause: $e"); }
     }
  }

   Future<void> stop() async {
     try { await _audioPlayer.stop(); }
     catch (e) { debugPrint("PlayerNotifier: Error calling stop: $e"); }
  }

  Future<void> seek(Duration position) async {
    final clampedPosition = position.isNegative
        ? Duration.zero
        : (position > state.totalDuration ? state.totalDuration : position);
     try {
       await _audioPlayer.seek(clampedPosition);
       _updateCurrentSegment(clampedPosition);
       state = state.copyWith(currentPosition: clampedPosition);
     } catch (e) {
       debugPrint("PlayerNotifier: Error calling seek: $e");
       state = state.copyWith(errorMessage: "Could not seek audio position.");
     }
  }

   void seekToSegment(int index) {
      if (index >= 0 && index < _transcript.length) {
         seek(_transcript[index].startTime);
         if (!state.playerState.playing &&
             _audioPlayer.processingState != ProcessingState.loading &&
             _audioPlayer.processingState != ProcessingState.buffering) {
           play();
         }
      }
   }

   void skipBackward() {
       seek(state.currentPosition - const Duration(seconds: 10));
   }

   void skipForward() {
      seek(state.currentPosition + const Duration(seconds: 10));
   }

   Future<void> changeSpeed() async {
        const speeds = [1.0, 1.5, 2.0, 0.75];
        final currentIndex = speeds.indexOf(state.playbackSpeed);
        final nextSpeed = speeds[(currentIndex + 1) % speeds.length];
        try {
          await _audioPlayer.setSpeed(nextSpeed);
          state = state.copyWith(playbackSpeed: nextSpeed);
        } catch (e) {
           debugPrint("PlayerNotifier: Error setting speed: $e");
           state = state.copyWith(errorMessage: "Could not change playback speed.");
        }
    }

  // No need for manual dispose method - ref.onDispose handles it.
}

// Note: The actual provider `playerProvider` is generated by the build_runner
// in the `player_provider.g.dart` file. You no longer manually define it.
// You will use `ref.watch(playerProvider)` and `ref.read(playerProvider.notifier)`
// in your UI code.