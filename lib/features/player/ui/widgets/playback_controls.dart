import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import hooks
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Use HookConsumerWidget
import 'package:just_audio/just_audio.dart';

// Import the generated player provider
import '../../providers/player_provider.dart';

// Available playback speeds - Define this list here or import from a constants file
const List<double> _playbackSpeeds = [0.75, 1.0, 1.25, 1.5, 2.0];

class PlaybackControls extends HookConsumerWidget {
  final bool hasError; // Keep if using explicit disabling

  const PlaybackControls({super.key, this.hasError = false});

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final notifier = ref.read(playerProvider.notifier);
    final bool isPlaying = playerState.playerState.playing;
    final ProcessingState processingState = playerState.playerState.processingState;
    // Use local state via hooks for the speed control bar visibility
    final showSpeedControl = useState(false);
    final timer = useRef<Timer?>(null); // useRef for mutable timer object

    // Function to toggle speed control visibility and manage auto-hide
    void toggleSpeedControl() {
      // Cancel any existing timer if toggling again
      if (timer.value?.isActive ?? false) {
        timer.value!.cancel();
      }
      // Toggle visibility state
      showSpeedControl.value = !showSpeedControl.value;
      // If now visible, start the auto-hide timer
      if (showSpeedControl.value) {
        timer.value = Timer(const Duration(seconds: 5), () {
          // Check if widget is still mounted before updating state
           if (context.mounted) {
             showSpeedControl.value = false;
           }
        });
      }
    }

    // Cleanup timer on dispose using useEffect hook
    useEffect(() {
      return () {
        // This function runs when the widget is disposed
        timer.value?.cancel();
      };
    }, const []); // Empty dependency array means run only on mount/unmount


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.1),
             spreadRadius: 0,
             blurRadius: 10,
             offset: const Offset(0, -2),
           ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Speed Control Bar (Conditionally Visible) ---
          if (showSpeedControl.value) // Use the state hook value
             _buildSpeedControlBar(context, playerState.playbackSpeed, notifier, showSpeedControl),

          // --- Progress Row ---
          Row(
            children: [
               Padding( // Current Time
                 padding: const EdgeInsets.only(right: 8.0),
                 child: Text(
                   _formatDuration(playerState.currentPosition),
                   style: Theme.of(context).textTheme.bodySmall,
                 ),
               ),
              Expanded( // Slider
                child: (playerState.totalDuration > Duration.zero)
                    ? Slider(
                        value: playerState.currentPosition.inMilliseconds.toDouble().clamp(0.0, playerState.totalDuration.inMilliseconds.toDouble()),
                        min: 0.0,
                        max: playerState.totalDuration.inMilliseconds.toDouble(),
                        secondaryTrackValue: playerState.bufferedPosition.inMilliseconds.toDouble().clamp(0.0, playerState.totalDuration.inMilliseconds.toDouble()),
                        onChanged: hasError ? null : (value) {
                           notifier.seek(Duration(milliseconds: value.toInt()));
                         },
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      )
                    : const Slider(value: 0.0, min: 0.0, max: 1.0, onChanged: null),
              ),
               Padding( // Total Time
                 padding: const EdgeInsets.only(left: 8.0),
                 child: Text(
                   _formatDuration(playerState.totalDuration),
                   style: Theme.of(context).textTheme.bodySmall,
                 ),
               ),
            ],
          ),
          const SizedBox(height: 0),

          // --- Control Buttons Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // *** This crossAxisAlignment is for the ROW, aligning buttons vertically ***
            // *** It should NOT cause an error unless there's a typo elsewhere ***
            crossAxisAlignment: CrossAxisAlignment.center, // <-- This line is likely OKAY
            children: [
              // --- Speed Button (Toggles Bar) ---
              SizedBox(
                width: 60,
                child: InkWell(
                  // *** Ensure onTap calls toggleSpeedControl, NOT changeSpeed ***
                  onTap: hasError ? null : toggleSpeedControl, // <-- CORRECTED: Calls the toggle function
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      '${playerState.playbackSpeed.toStringAsFixed(playerState.playbackSpeed % 1 == 0 ? 0 : 2)}x',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ),
const Spacer(),
              // --- Skip Backward Button ---
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 20),
                tooltip: "Rewind 10 seconds",
                onPressed: hasError ? null : notifier.skipBackward,
              ),

              // --- Play/Pause/Replay/Loading Button ---
              SizedBox(
                width: 54,
                height: 54,
                child: _buildPlayPauseButton(context, isPlaying, processingState, notifier, hasError: hasError),
              ),

              // --- Skip Forward Button ---
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 20),
                tooltip: "Forward 10 seconds",
                onPressed: hasError ? null : notifier.skipForward,
              ),
              // --- Placeholder for alignment ---
              const Spacer(),
              const SizedBox(width: 60),


            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // --- Helper to build the speed control bar ---
  Widget _buildSpeedControlBar(
      BuildContext context,
      double currentSpeed,
      Player notifier,
      ValueNotifier<bool> showSpeedControl // Receive ValueNotifier to hide bar
      ) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _playbackSpeeds.map((speed) {
          final bool isSelected = currentSpeed == speed;
          return InkWell(
            onTap: () {
              notifier.setSpeed(speed); // Use the correct setSpeed method
              showSpeedControl.value = false; // Hide bar after selection
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              child: Text(
                '${speed.toStringAsFixed(speed % 1 == 0 ? 0 : 2)}x',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper to build play/pause button (includes hasError check)
    Widget _buildPlayPauseButton(
    BuildContext context,
    bool isPlaying,
    ProcessingState processingState,
    Player notifier, {
    bool hasError = false,
  }) {
    final bool isDisabled = hasError;
    final Color iconColor = isDisabled
        ? Theme.of(context).disabledColor
        : Theme.of(context).colorScheme.primary;
    final double iconSize = 50.0; // 定义图标大小

    // --- Loading/Buffering State ---
    if (!isDisabled && (processingState == ProcessingState.loading || processingState == ProcessingState.buffering)) {
      // Keep loading indicator as before
      return Center(
          child: SizedBox(
              width: iconSize * 0.6, // Make indicator smaller than button
              height: iconSize * 0.6,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor))));
    }
    // --- Normal Button State ---
    else {
      // Determine the appropriate icon
      final IconData iconData = (isPlaying)
          ? Icons.pause_circle_filled
          : (processingState == ProcessingState.completed
              ? Icons.replay_circle_filled
              : Icons.play_circle_filled);

      // Define the action for the button press
      final VoidCallback? onPressedAction = isDisabled
          ? null
          : () {
              if (isPlaying) {
                notifier.pause();
              } else if (processingState == ProcessingState.completed) {
                notifier.seek(Duration.zero);
                notifier.play();
              } else {
                notifier.play();
              }
            };

      // --- Use InkWell for better ripple effect control ---
      return Center( // Center the InkWell/Icon area if needed within its parent SizedBox
        child: Material( // Material needed for InkWell splashes to render correctly on some backgrounds
          color: Colors.transparent, // Make Material background transparent
          shape: const CircleBorder(), // Define the shape for clipping ripple
          clipBehavior: Clip.antiAlias, // Clip the ripple effect to the circle
          child: InkWell(
            onTap: onPressedAction, // Assign the determined action
            // customBorder: const CircleBorder(), // Alternative way to define shape for ripple
             splashColor: iconColor.withOpacity(0.2), // Customize splash color
             highlightColor: iconColor.withOpacity(0.1), // Customize highlight color
            child: Padding(
              // Add padding if needed inside the tap area, otherwise icon fills it
              padding: const EdgeInsets.all(2.0), // Small padding around the icon
              child: Icon(
                iconData,
                size: iconSize,
                color: iconColor,
                semanticLabel: isDisabled ? null : (isPlaying ? "Pause" : "Play"), // Tooltip alternative
              ),
            ),
          ),
        ),
      );
    }
  }
}