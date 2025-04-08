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

    // --- Timer Management Function ---
    // Encapsulate timer starting/cancelling logic
    void resetAutoHideTimer() {
      timer.value?.cancel(); // Cancel existing timer
      timer.value = Timer(const Duration(seconds: 5), () {
        // Start new 5-second timer
        if (context.mounted) {
          showSpeedControl.value = false; // Hide after timeout
        }
      });
    }

    // --- Toggle Speed Control Visibility ---
    void toggleSpeedControl() {
      final newVisibility = !showSpeedControl.value;
      showSpeedControl.value = newVisibility; // Update visibility state

      if (newVisibility) {
        resetAutoHideTimer(); // Start/Reset timer when shown
      } else {
        timer.value?.cancel(); // Cancel timer if hidden manually
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
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Speed Control Bar (Conditionally Visible) ---
          if (showSpeedControl.value) // Use the state hook value
            _buildSpeedControlBar(context, playerState.playbackSpeed, notifier, showSpeedControl,resetAutoHideTimer),

          // --- Progress Row ---
          Row(
            children: [
              Padding(
                // Current Time
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(_formatDuration(playerState.currentPosition), style: Theme.of(context).textTheme.bodySmall),
              ),
              Expanded(
                // Slider
                child:
                    (playerState.totalDuration > Duration.zero)
                        ? Slider(
                          value: playerState.currentPosition.inMilliseconds.toDouble().clamp(
                            0.0,
                            playerState.totalDuration.inMilliseconds.toDouble(),
                          ),
                          min: 0.0,
                          max: playerState.totalDuration.inMilliseconds.toDouble(),
                          secondaryTrackValue: playerState.bufferedPosition.inMilliseconds.toDouble().clamp(
                            0.0,
                            playerState.totalDuration.inMilliseconds.toDouble(),
                          ),
                          onChanged:
                              hasError
                                  ? null
                                  : (value) {
                                    notifier.seek(Duration(milliseconds: value.toInt()));
                                  },
                          activeColor: Theme.of(context).colorScheme.primary,
                          inactiveColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        )
                        : const Slider(value: 0.0, min: 0.0, max: 1.0, onChanged: null),
              ),
              Padding(
                // Total Time
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(_formatDuration(playerState.totalDuration), style: Theme.of(context).textTheme.bodySmall),
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
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      '${playerState.playbackSpeed.toStringAsFixed(playerState.playbackSpeed % 1 == 0 ? 0 : 2)}x',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
    ValueNotifier<bool> showSpeedControl,
    VoidCallback resetTimerCallback // Receive ValueNotifier to hide bar
  ) {
    // Define colors for better readability
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color selectedTextColor = Colors.white; // Or Theme.of(context).colorScheme.onPrimary
    final Color defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    // Define background color for the bar - slightly different from main background
    final Color barBackgroundColor = Theme.of(
      context,
    ).colorScheme.surfaceVariant.withOpacity(0.6); // Example using surfaceVariant
    // Or use a specific color:
    // final Color barBackgroundColor = Colors.grey[200]!;

    return Container(
      // --- Outer Container for Background and Shape ---
      margin: const EdgeInsets.only(bottom: 12.0, left: 0.0, right: 0.0), // Add horizontal margin too
      padding: const EdgeInsets.symmetric(vertical: 2.0), // Padding inside the bar
      decoration: BoxDecoration(
        color: barBackgroundColor, // Apply the background color
        // Use StadiumBorder for an oval/pill shape
        borderRadius: BorderRadius.circular(20.0), // Or use StadiumBorder()
        // Optional: Add a subtle border
        // border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute speed options evenly
        children:
            _playbackSpeeds.map((speed) {
              final bool isSelected = currentSpeed == speed;

              // --- Container for Individual Speed Option ---
              // Wrap InkWell with a Container to apply the circular background when selected
              return Container(
                decoration: BoxDecoration(
                  // Apply circular background only if selected
                  color: isSelected ? primaryColor : Colors.transparent,
                  shape: BoxShape.circle, // Make the background circular
                ),
                // Material needed for InkWell clipping and splash on colored background
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      notifier.setSpeed(speed);
                      resetTimerCallback(); // <-- Call the reset timer callback here
                      // showSpeedControl.value = false; // Hide bar after selection
                    },
                    // borderRadius: BorderRadius.circular(20), // Make ripple effect circular too
                    splashColor: primaryColor.withOpacity(0.2),
                    highlightColor: primaryColor.withOpacity(0.1),
                    child: Padding(
                      // Adjust padding to control the size of the tap target and text position
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Text(
                        '${speed.toStringAsFixed(speed % 1 == 0 ? 0 : 2)}x',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          // Set text color based on selection
                          color: isSelected ? selectedTextColor : defaultTextColor,
                        ),
                      ),
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
    final Color iconColor = isDisabled ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary;
    final double iconSize = 50.0; // 定义图标大小

    // --- Loading/Buffering State ---
    if (!isDisabled && (processingState == ProcessingState.loading || processingState == ProcessingState.buffering)) {
      // Keep loading indicator as before
      return Center(
        child: SizedBox(
          width: iconSize * 0.6, // Make indicator smaller than button
          height: iconSize * 0.6,
          child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(iconColor)),
        ),
      );
    }
    // --- Normal Button State ---
    else {
      // Determine the appropriate icon
      final IconData iconData =
          (isPlaying)
              ? Icons.pause_circle_filled
              : (processingState == ProcessingState.completed ? Icons.replay_circle_filled : Icons.play_circle_filled);

      // Define the action for the button press
      final VoidCallback? onPressedAction =
          isDisabled
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
      return Center(
        // Center the InkWell/Icon area if needed within its parent SizedBox
        child: Material(
          // Material needed for InkWell splashes to render correctly on some backgrounds
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
