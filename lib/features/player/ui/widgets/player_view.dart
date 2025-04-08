import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../providers/player_provider.dart';
import 'playback_controls.dart';

class PlayerView extends ConsumerWidget {
  final ListeningMaterial material;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const PlayerView({
    super.key,
    required this.material,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);

    // Determine if there's an error that prevents playback
    final bool hasPlaybackError = playerState.errorMessage != null;

    // --- Build Main Player UI Structure ALWAYS ---
    return Column(
      children: [
        // --- Transcript Area ---
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // Optionally, display an error overlay *over* the transcript
            child: Stack( // Use Stack to overlay error message if needed
              children: [
                // Build transcript list regardless of error
                ScrollablePositionedList.builder(
                  itemCount: material.transcript.length,
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (context, index) {
                    final TranscriptSegment segment = material.transcript[index];
                    final bool isCurrent = index == playerState.currentSegmentIndex && !hasPlaybackError; // Don't highlight if error
                    final Color currentTextColor = Theme.of(context).colorScheme.primary;
                    final Color defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
                    final Color chineseTextColor = Colors.grey[600]!;
                    final Color errorColor = Theme.of(context).colorScheme.error.withOpacity(0.6); // Muted error color

                    return InkWell(
                      // Disable seeking if there's an error
                      onTap: hasPlaybackError ? null : () => playerNotifier.seekToSegment(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              segment.englishText,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                // Dim text color slightly if there's an error
                                color: hasPlaybackError ? defaultTextColor.withOpacity(0.7) : (isCurrent ? currentTextColor : defaultTextColor),
                                height: 1.5,
                              ),
                            ),
                            if (segment.chineseText.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                segment.chineseText,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: hasPlaybackError ? chineseTextColor.withOpacity(0.7) : (isCurrent ? currentTextColor.withOpacity(0.85) : chineseTextColor),
                                  height: 1.4,
                                ),
                              ),
                            ],
                            // Optionally add a subtle indicator per line on error
                            // if (hasPlaybackError) Divider(color: errorColor, height: 1, thickness: 0.5),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // --- Error Overlay ---
                // Show an informative overlay if there's an error
                if (hasPlaybackError)
                  Positioned.fill(
                    child: Container(
                      // Semi-transparent background to indicate issue without hiding text completely
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                  Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 40),
                                  const SizedBox(height: 10),
                                  Text(
                                      "Could not load audio: ${playerState.errorMessage}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                                  ),
                                  // Optionally add a retry button if applicable
                                  // ElevatedButton(onPressed: () => playerNotifier.loadMaterial(material), child: Text("Retry"))
                              ]
                          )
                        ),
                      ),
                    ),
                  ),

                // Show loading indicator specifically during initial load
                if (playerState.isLoading)
                    Positioned.fill(
                        child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                            child: const Center(child: CircularProgressIndicator())
                        )
                    )
              ],
            ),
          ),
        ),

        // --- Playback Controls Area ---
        // Pass the error state to PlaybackControls so it can disable buttons
        PlaybackControls(
            // Pass error state down - PlaybackControls needs modification
            // hasError: hasPlaybackError, // Add this parameter to PlaybackControls
        ),
        // OR simply render the controls, they might look enabled but won't work
        // if the player state prevents actions (e.g., trying to play when state is error/idle)
        // const PlaybackControls(), // Keeps existing structure
      ],
    );
  }
}