import 'dart:async'; // Required for StreamSubscription
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter/scheduler.dart'; // For SchedulerBinding
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Base Riverpod (needed by generated code)
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/player_screen_state.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // Annotation package
import 'package:just_audio/just_audio.dart'; // The audio player library
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For transcript scrolling

part 'player_provider.g.dart'; // Generated code for Riverpod
// Ensure these import paths match your project structure


/// Defines the Player Notifier using Riverpod code generation.
///
/// Manages audio playback state and logic using just_audio, handles user actions,
/// and synchronizes transcript scrolling conditionally based on item visibility,
/// list scroll boundaries, and whether the update was triggered by user interaction
/// or automatic playback progression.
@riverpod // Default: keepAlive: false (autoDispose)
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
    debugPrint("PlayerNotifier: ItemScrollController set.");
  }

  /// Allows the UI to provide the ItemPositionsListener.
  void setPositionsListener(ItemPositionsListener listener) {
    _itemPositionsListener = listener;
     debugPrint("PlayerNotifier: ItemPositionsListener set.");
     // Optional: Add listener here if needed for real-time reactions
     // _itemPositionsListener?.itemPositions.addListener(_handleVisibleItemsChanged);
  }

  /// Sets up listeners for just_audio player streams.
  void _listenToPlayerStreams() {
    // Player State Stream
    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      (playerState) {
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

    // Position Stream - Drives automatic updates
    _positionSubscription = _audioPlayer.positionStream.listen(
        (position) {
          // Update segment based on position, indicating it's NOT from seek
          _updateCurrentSegment(position, triggeredBySeek: false);
          // Update currentPosition state
          state = state.copyWith(currentPosition: position);
        },
        onError: (e, stackTrace) { debugPrint("Error in positionStream: $e"); }
    );

    // Duration Stream
    _durationSubscription = _audioPlayer.durationStream.listen(
        (duration) { state = state.copyWith(totalDuration: duration ?? Duration.zero); },
        onError: (e, stackTrace) { debugPrint("Error in durationStream: $e"); }
    );

    // Buffered Position Stream
    _bufferedPositionSubscription = _audioPlayer.bufferedPositionStream.listen(
        (position) { state = state.copyWith(bufferedPosition: position); },
        onError: (e, stackTrace) { debugPrint("Error in bufferedPositionStream: $e"); }
    );
  }

  /// Loads new audio material into the player.
  Future<void> loadMaterial(ListeningMaterial material) async {
     // Reset transcript before loading
     _transcript = [];
     // Reset state immediately to show loading and clear previous errors/data
     state = PlayerScreenState.initial().copyWith(isLoading: true);

    if (material.audioUrl.isEmpty) {
      state = state.copyWith(isLoading: false, errorMessage: "Audio URL is missing.");
      debugPrint("PlayerNotifier: Error - Audio URL is empty for material ID ${material.id}");
      return;
    }
    debugPrint("PlayerNotifier: Loading material ID ${material.id} - URL: ${material.audioUrl}");
    // No need to set isLoading again here, already done above

    try {
      _transcript = material.transcript; // Set transcript for the new material
      await _audioPlayer.stop(); // Ensure full stop

      // Don't reset state again here, just update after loading
      final effectiveDuration = await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(material.audioUrl)),
        preload: true,
      );
      debugPrint("PlayerNotifier: Material loaded. Effective duration: $effectiveDuration");
      state = state.copyWith(
        totalDuration: effectiveDuration ?? Duration.zero,
        isLoading: false, // Loading finished
        errorMessage: null, // Clear previous errors
        playbackSpeed: _audioPlayer.speed,
        currentSegmentIndex: -1, // Ensure index is reset after loading
        currentPosition: Duration.zero, // Ensure position is reset
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

  /// Updates segment index based on position and decides whether to check for auto-scroll.
  void _updateCurrentSegment(Duration position, {bool triggeredBySeek = false}) {
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
        _transcript.isNotEmpty &&
        position >= _transcript.last.startTime &&
        position <= (state.totalDuration + const Duration(milliseconds: 200))) {
      newIndex = _transcript.length - 1;
    }

    if (newIndex != state.currentSegmentIndex) {
      state = state.copyWith(currentSegmentIndex: newIndex);

      // --- Optional Auto-Scroll Logic ---
      // Only check for scrolling if update was NOT triggered by user seek
      // AND if the index is valid.
      if (!triggeredBySeek && newIndex != -1) {
         // Check if auto-scrolling is needed (item too low and list not at bottom)
         _checkAndScrollIfNeeded(newIndex, triggeredByAutoPlay: true);
      }
    }
  }

  /// Scrolls the list to bring the target index to the top (alignment: 0.0).
  void _scrollToIndex(int index) {
    if (_itemScrollController != null && _itemScrollController!.isAttached) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_itemScrollController != null && _itemScrollController!.isAttached) {
          debugPrint("PlayerNotifier: Scrolling to index $index (alignment: 0.0)");
          _itemScrollController!.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            alignment: 0.0, // Align item top to viewport top
          );
        } else {
           debugPrint("PlayerNotifier: Scroll cancelled, controller detached during callback.");
        }
      });
    } else {
       debugPrint("PlayerNotifier: Cannot scroll, ItemScrollController not available or attached.");
    }
  }

  /// Checks visibility and position, scrolling if needed based on trigger source.
  void _checkAndScrollIfNeeded(int targetIndex, {bool triggeredByAutoPlay = false}) {
    // Prerequisites check
    if (_itemPositionsListener == null) {
       debugPrint("PlayerNotifier: CheckScroll skipped, ItemPositionsListener is null.");
       // Fallback? Maybe scroll if auto-playing? Depends on desired behavior.
       // if (triggeredByAutoPlay && targetIndex != -1) _scrollToIndex(targetIndex);
       return;
    }
     if (_itemScrollController == null || !_itemScrollController!.isAttached) {
        debugPrint("PlayerNotifier: CheckScroll skipped, ItemScrollController not available/attached.");
        return;
     }
     if (targetIndex < 0) { // Ensure valid index
        debugPrint("PlayerNotifier: CheckScroll skipped, invalid target index $targetIndex.");
        return;
     }

    // Get visible positions
    final positions = _itemPositionsListener!.itemPositions.value;
    if (positions.isEmpty) {
      debugPrint("PlayerNotifier: No visible items reported, scrolling directly for index $targetIndex.");
       // Fallback scroll if list likely not ready
      _scrollToIndex(targetIndex);
      return;
    }

    // Find target position among visible items
    ItemPosition? targetPosition;
    for (var pos in positions) {
      if (pos.index == targetIndex) {
        targetPosition = pos;
        break;
      }
    }

    bool shouldScroll = false;
    final String triggerSource = triggeredByAutoPlay ? "AutoPlay" : "UserTap";

    if (targetPosition == null) {
      // Case 1: Target not visible - ALWAYS scroll
      shouldScroll = true;
      debugPrint("$triggerSource: Checking scroll for index $targetIndex. Target not visible. Should scroll.");
    } else {
      // Case 2: Target is visible - Apply different logic based on trigger
      final lastVisibleItem = positions.last;
      final bool isAtBottom = lastVisibleItem.index == _transcript.length - 1 &&
                             lastVisibleItem.itemTrailingEdge <= 1.01; // Tolerance

      if (triggeredByAutoPlay) {
        // --- AutoPlay Scroll Logic ---
        if (isAtBottom) {
          // Don't scroll if already at the very bottom
          shouldScroll = false;
          debugPrint("$triggerSource: Checking scroll for index $targetIndex. List at bottom. No scroll.");
        } else {
          // Scroll if target is too low
          const double autoPlayScrollThreshold = 0.6; // Adjust threshold
          if (targetPosition.itemLeadingEdge > autoPlayScrollThreshold) {
            shouldScroll = true;
            debugPrint("$triggerSource: Checking scroll for index $targetIndex. Target visible but too low (top edge at ${targetPosition.itemLeadingEdge.toStringAsFixed(2)}). Should scroll.");
          } else {
             shouldScroll = false; // Already in comfortable position
             debugPrint("$triggerSource: Checking scroll for index $targetIndex. Target visible and within threshold.");
          }
        }
      } else {
        // --- User Tap Scroll Logic ---
        // User tapped a visible item. Do NOT scroll.
        shouldScroll = false;
        debugPrint("$triggerSource: Checking scroll for index $targetIndex. Target visible. No scroll.");
      }
    }

    // Execute scroll action if decided
    if (shouldScroll) {
      _scrollToIndex(targetIndex);
    } else {
       debugPrint("Target index $targetIndex requires no scroll action for $triggerSource.");
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
    } catch (e) {
      debugPrint("PlayerNotifier: Error calling stop: $e");
    }
  }

  /// Seeks audio position and updates state. Does not handle scroll logic itself.
  Future<void> seek(Duration position) async {
    final clampedPosition = position.isNegative
        ? Duration.zero
        : (position > state.totalDuration ? state.totalDuration : position);
    try {
      await _audioPlayer.seek(clampedPosition);
      // Pass triggeredBySeek: true so _updateCurrentSegment doesn't check for auto-scroll
      _updateCurrentSegment(clampedPosition, triggeredBySeek: true);
      state = state.copyWith(currentPosition: clampedPosition);
    } catch (e) {
      debugPrint("PlayerNotifier: Error calling seek: $e");
      state = state.copyWith(errorMessage: "Could not seek audio position.");
    }
  }

  /// Called when a user taps a transcript segment. Seeks audio and handles conditional scroll.
  void seekToSegment(int index) {
    if (index >= 0 && index < _transcript.length) {
      // 1. Seek the audio player (this calls _updateCurrentSegment with triggeredBySeek: true)
      seek(_transcript[index].startTime);

      // 2. Explicitly check scroll logic for a user tap action
      _checkAndScrollIfNeeded(index, triggeredByAutoPlay: false); // Pass false

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
    // Optional: Check scroll after delay if needed
    // Future.delayed(const Duration(milliseconds: 100), () => _checkAndScrollIfNeeded(state.currentSegmentIndex, triggeredByAutoPlay: false)); // Indicate it's like a user action
  }

  /// Skips playback forward by 10 seconds.
  void skipForward() {
    final targetPosition = state.currentPosition + const Duration(seconds: 10);
    seek(targetPosition);
     // Optional: Check scroll after delay
    // Future.delayed(const Duration(milliseconds: 100), () => _checkAndScrollIfNeeded(state.currentSegmentIndex, triggeredByAutoPlay: false));
  }

  /// Sets the playback speed to a specific value.
  Future<void> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
      state = state.copyWith(playbackSpeed: speed);
    } catch (e) {
      debugPrint("PlayerNotifier: Error setting speed to $speed: $e");
      state = state.copyWith(errorMessage: "Could not change playback speed.");
    }
  }

} // End of Player class