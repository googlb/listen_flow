import 'dart:async'; // Required for StreamSubscription
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For SchedulerBinding
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Base Riverpod (needed by generated code)
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/player_screen_state.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // Annotation package
import 'package:just_audio/just_audio.dart'; // The audio player library
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For transcript scrolling

// Correct import paths for your models and state


// Necessary part directive for the generator
part 'player_provider.g.dart';

/// Defines the Player Notifier using Riverpod code generation.
///
/// Manages audio playback state and logic using just_audio, handles user actions,
/// and synchronizes transcript scrolling conditionally based on item visibility.
@riverpod // Default is keepAlive: false (autoDispose)
class Player extends _$Player {
  /// The instance of the just_audio player.
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Holds the transcript data for the currently loaded material.
  List<TranscriptSegment> _transcript = [];

  // Stream subscriptions for cleaning up listeners.
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _bufferedPositionSubscription;

  // Controllers and Listeners injected from the UI.
  ItemScrollController? _itemScrollController;
  ItemPositionsListener? _itemPositionsListener;

  /// Build method: Initializes state and listeners, sets up disposal logic.
  @override
  PlayerScreenState build() {
    debugPrint("Player provider built. Initializing listener streams.");
    _listenToPlayerStreams();

    ref.onDispose(() {
      debugPrint("Disposing Player provider...");
      _playerStateSubscription?.cancel();
      _positionSubscription?.cancel();
      _durationSubscription?.cancel();
      _bufferedPositionSubscription?.cancel();
      _audioPlayer.dispose();
      debugPrint("Player provider disposed.");
    });

    return PlayerScreenState.initial();
  }

  /// Allows the UI to provide the ItemScrollController.
  void setScrollController(ItemScrollController controller) {
    _itemScrollController = controller;
  }

  /// Allows the UI to provide the ItemPositionsListener.
  void setPositionsListener(ItemPositionsListener listener) {
    _itemPositionsListener = listener;
  }

  /// Sets up listeners for just_audio player streams.
  void _listenToPlayerStreams() {
    // Player State Stream
    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      (playerState) {
        // Primarily update playerState; reset index only on completion/idle.
        // Let positionStream handle segment updates during active playback.
        state = state.copyWith(
          playerState: playerState,
          currentSegmentIndex: (playerState.processingState == ProcessingState.completed ||
                                 playerState.processingState == ProcessingState.idle)
                              ? -1 : state.currentSegmentIndex,
        );
      },
       onError: (e, stackTrace) {
          debugPrint("Error in playerStateStream: $e");
          state = state.copyWith(errorMessage: "Player state error: $e");
       }
    );

    // Position Stream
    _positionSubscription = _audioPlayer.positionStream.listen(
        (position) {
          // Update segment index based on the new position.
          _updateCurrentSegment(position);
          // Update the current position state.
          state = state.copyWith(currentPosition: position);
        },
        onError: (e, stackTrace) {
            debugPrint("Error in positionStream: $e");
            // Less critical to show error for position stream usually
        }
    );

    // Duration Stream
    _durationSubscription = _audioPlayer.durationStream.listen(
        (duration) {
          state = state.copyWith(totalDuration: duration ?? Duration.zero);
        },
        onError: (e, stackTrace) {
            debugPrint("Error in durationStream: $e");
        }
    );

    // Buffered Position Stream
    _bufferedPositionSubscription = _audioPlayer.bufferedPositionStream.listen(
        (position) {
          state = state.copyWith(bufferedPosition: position);
        },
        onError: (e, stackTrace) {
            debugPrint("Error in bufferedPositionStream: $e");
        }
    );
  }

  /// Loads new audio material into the player.
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
      await _audioPlayer.stop(); // Ensure full stop before loading new
      state = PlayerScreenState.initial().copyWith(isLoading: true); // Reset state

      final effectiveDuration = await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(material.audioUrl)),
        preload: true, // Preload for faster start
      );
      debugPrint("PlayerNotifier: Material loaded. Effective duration: $effectiveDuration");
      state = state.copyWith(
        totalDuration: effectiveDuration ?? Duration.zero,
        isLoading: false,
        playbackSpeed: _audioPlayer.speed, // Reflect current player speed
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

  /// Updates the current transcript segment index based on playback position.
  void _updateCurrentSegment(Duration position) {
    int newIndex = -1;
    if (_transcript.isEmpty || state.totalDuration <= Duration.zero) {
      if (state.currentSegmentIndex != -1) {
        state = state.copyWith(currentSegmentIndex: -1);
      }
      return;
    }

    // Find matching segment
    for (int i = 0; i < _transcript.length; i++) {
      // Add buffer for smoother transitions
      if (position >= _transcript[i].startTime &&
          position < (_transcript[i].endTime + const Duration(milliseconds: 100))) {
        newIndex = i;
        break;
      }
    }

    // Handle edge case for the last segment
    if (newIndex == -1 &&
        _transcript.isNotEmpty &&
        position >= _transcript.last.startTime &&
        position <= (state.totalDuration + const Duration(milliseconds: 200))) {
      newIndex = _transcript.length - 1;
    }

    // Update state only if the index actually changed
    if (newIndex != state.currentSegmentIndex) {
      state = state.copyWith(currentSegmentIndex: newIndex);

      // --- Optional: Auto-scroll during normal playback ---
      // If you want the view to scroll automatically as audio plays
      // and the highlighted item goes out of view or gets too low,
      // uncomment the line below. Otherwise, scrolling only happens
      // when the user explicitly taps via seekToSegment.
      // _checkAndScrollIfNeeded(newIndex);
    }
  }

  /// Scrolls the list to bring the target index to the top of the viewport.
  void _scrollToIndex(int index) {
    if (_itemScrollController != null && _itemScrollController!.isAttached) {
      // Ensure scroll happens after the current frame build/layout phase
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Double-check attachment in case widget disposed during callback delay
        if (_itemScrollController != null && _itemScrollController!.isAttached) {
          _itemScrollController!.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 400), // Animation duration
            curve: Curves.easeInOutCubic, // Animation curve
            alignment: 0.0, // Align item top to viewport top
          );
        }
      });
    } else {
       debugPrint("PlayerNotifier: Cannot scroll, ItemScrollController not available or attached.");
    }
  }

  /// Checks if the target index is visible and positioned comfortably,
  /// otherwise triggers a scroll to bring it to the top.
  void _checkAndScrollIfNeeded(int targetIndex) {
    // Ensure prerequisites are met
    if (_itemPositionsListener == null) {
       debugPrint("PlayerNotifier: Cannot check visibility, ItemPositionsListener is null.");
       // Fallback: Scroll directly if listener isn't set (might happen briefly)
       if (targetIndex != -1) _scrollToIndex(targetIndex);
       return;
    }
     if (_itemScrollController == null || !_itemScrollController!.isAttached) {
        debugPrint("PlayerNotifier: Cannot scroll, ItemScrollController not available/attached.");
        // No scrolling possible if controller isn't ready
        return;
     }

    // Get current visible item positions
    final positions = _itemPositionsListener!.itemPositions.value;
    if (positions.isEmpty) {
      // List might not be rendered yet, fallback to scrolling
      debugPrint("PlayerNotifier: No visible items reported, scrolling directly.");
      if (targetIndex != -1) _scrollToIndex(targetIndex);
      return;
    }

    // Find the position data for the target index among visible items
    ItemPosition? targetPosition;
    for (var pos in positions) {
      if (pos.index == targetIndex) {
        targetPosition = pos;
        break;
      }
    }

    bool shouldScroll = false;
    if (targetPosition == null) {
      // Case 1: Target index is not currently visible at all.
      shouldScroll = true;
      debugPrint("Checking scroll for index $targetIndex. Target not visible. Should scroll.");
    } else {
      // Case 2: Target index is visible. Check if it's too low.
      // Threshold: If item's top edge is below this percentage of the viewport height, scroll.
      const double scrollThreshold = 0.6; // Example: Scroll if top edge is below 60% down. Adjust as needed.

      if (targetPosition.itemLeadingEdge > scrollThreshold) {
        shouldScroll = true;
        debugPrint("Checking scroll for index $targetIndex. Target visible but too low (top edge at ${targetPosition.itemLeadingEdge.toStringAsFixed(2)}). Should scroll.");
      } else {
        // Target is visible and high enough, no need to scroll.
         debugPrint("Checking scroll for index $targetIndex. Target visible and within threshold (top edge at ${targetPosition.itemLeadingEdge.toStringAsFixed(2)}).");
      }
    }

    // Execute scroll only if needed and index is valid
    if (shouldScroll && targetIndex != -1) {
      _scrollToIndex(targetIndex);
    } else if (targetIndex != -1) {
       debugPrint("Target index $targetIndex requires no scroll action.");
    }
  }


  // --- Public Methods for Playback Control ---

  Future<void> play() async {
    if (!state.playerState.playing &&
        _audioPlayer.processingState != ProcessingState.loading &&
        _audioPlayer.processingState != ProcessingState.buffering) {
      try {
        await _audioPlayer.play();
      } catch (e) {
        debugPrint("PlayerNotifier: Error calling play: $e");
        state = state.copyWith(errorMessage: "Could not start playback.");
      }
    }
  }

  Future<void> pause() async {
    if (state.playerState.playing) {
      try {
        await _audioPlayer.pause();
      } catch (e) {
        debugPrint("PlayerNotifier: Error calling pause: $e");
      }
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      // State handled by listener
    } catch (e) {
      debugPrint("PlayerNotifier: Error calling stop: $e");
    }
  }

  /// Seeks audio position without necessarily triggering a scroll immediately.
  /// Scroll logic is handled by the calling context (e.g., seekToSegment).
  Future<void> seek(Duration position) async {
    final clampedPosition = position.isNegative
        ? Duration.zero
        : (position > state.totalDuration ? state.totalDuration : position);
    try {
      await _audioPlayer.seek(clampedPosition);
      // Optimistically update state for UI responsiveness
      _updateCurrentSegment(clampedPosition); // Update index based on target
      state = state.copyWith(currentPosition: clampedPosition); // Update position display
    } catch (e) {
      debugPrint("PlayerNotifier: Error calling seek: $e");
      state = state.copyWith(errorMessage: "Could not seek audio position.");
    }
  }

  /// Called when a user taps a transcript segment. Seeks audio and handles scrolling.
  void seekToSegment(int index) {
    if (index >= 0 && index < _transcript.length) {
      // 1. Seek the audio player (this will update state via streams/optimistic update)
      seek(_transcript[index].startTime);

      // 2. Check visibility and trigger scroll *only if needed*
      _checkAndScrollIfNeeded(index);

      // 3. Start playback if currently paused/stopped
      if (!state.playerState.playing &&
          _audioPlayer.processingState != ProcessingState.loading &&
          _audioPlayer.processingState != ProcessingState.buffering) {
        play();
      }
    }
  }

  /// Skips playback backward by 10 seconds.
  void skipBackward() {
    final targetPosition = state.currentPosition - const Duration(seconds: 10);
    seek(targetPosition);
    // Optional: Check scroll after a short delay to ensure visibility
    // Future.delayed(const Duration(milliseconds: 100), () => _checkAndScrollIfNeeded(state.currentSegmentIndex));
  }

  /// Skips playback forward by 10 seconds.
  void skipForward() {
    final targetPosition = state.currentPosition + const Duration(seconds: 10);
    seek(targetPosition);
    // Optional: Check scroll after a short delay
    // Future.delayed(const Duration(milliseconds: 100), () => _checkAndScrollIfNeeded(state.currentSegmentIndex));
  }

  /// Sets the playback speed to a specific value.
  Future<void> setSpeed(double speed) async {
     // Optional: Add validation if needed: e.g., if (!_playbackSpeeds.contains(speed)) return;
    try {
      await _audioPlayer.setSpeed(speed);
      state = state.copyWith(playbackSpeed: speed);
    } catch (e) {
      debugPrint("PlayerNotifier: Error setting speed to $speed: $e");
      state = state.copyWith(errorMessage: "Could not change playback speed.");
    }
  }

  // Note: The old changeSpeed cycling method is removed, assuming setSpeed is used by the UI.
  // Add it back if you need both interaction types.

} // End of Player class