import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // For ConsumerWidget and Consumer
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
// Correct import paths based on your structure (assuming models are in data/models)
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For the transcript list

// Import the player provider and playback controls widget
import '../../providers/player_provider.dart';
import 'playback_controls.dart';

/// PlayerView: A reusable widget displaying the core player interface.
///
/// Optimized using a Consumer within the list's itemBuilder to only rebuild
/// individual transcript items when their highlight state changes.
class PlayerView extends ConsumerWidget { // Remains ConsumerWidget to watch loading/error state
  /// The listening material containing the audio URL and transcript data.
  final ListeningMaterial material;

  /// Controller to programmatically scroll the transcript list.
  final ItemScrollController itemScrollController;

  /// Listener to observe the items currently visible in the transcript list.
  final ItemPositionsListener itemPositionsListener;

  /// Constructor requiring the material and scroll controllers.
  const PlayerView({
    super.key,
    required this.material,
    required this.itemScrollController,
    required this.itemPositionsListener,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Watch state needed for the OVERALL view (overlays) ---
    final isLoading = ref.watch(playerProvider.select((s) => s.isLoading));
    final errorMessage = ref.watch(playerProvider.select((s) => s.errorMessage));
    final hasPlaybackError = errorMessage != null;

    // Notifier is read once for actions, can be passed down or read inside Consumer
    final playerNotifier = ref.read(playerProvider.notifier);

    // Optional: Log PlayerView builds to confirm optimization
    // print("--- PlayerView build (isLoading: $isLoading, hasError: $hasPlaybackError) ---");

    // --- Build Main Player UI Structure ---
    return Column(
      children: [
        // --- Transcript Area ---
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Stack( // Stack for overlays
              children: [
                // --- Transcript List ---
                ScrollablePositionedList.builder(
                  itemCount: material.transcript.length,
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  // --- Item Builder for each transcript segment ---
                  itemBuilder: (context, index) {
                    // Get static data for the segment
                    final TranscriptSegment segment = material.transcript[index];

                    // --- Use Consumer for state needed ONLY by the item ---
                    return Consumer(
                      builder: (context, itemRef, child) {
                        // Watch ONLY the currentSegmentIndex needed for highlighting this item
                        final currentSegmentIndex = itemRef.watch(
                            playerProvider.select((s) => s.currentSegmentIndex));
                        // Determine if this specific item is current
                        final bool isCurrent = index == currentSegmentIndex && !hasPlaybackError;

                        // Optional: Log item rebuilds
                        // if (isCurrent) print("--- Transcript Item $index build (isCurrent: $isCurrent) ---");

                        // Define colors (can be outside Consumer if not state-dependent)
                        final Color currentTextColor = Theme.of(context).colorScheme.primary;
                        final Color defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
                        final Color chineseTextColor = Colors.grey[600]!;

                        // Build the actual list item widget
                        return InkWell(
                          // Use the notifier obtained outside the Consumer
                          onTap: hasPlaybackError ? null : () => playerNotifier.seekToSegment(index),
                          child: ConstrainedBox(
                            // Apply consistent minimum height
                            constraints: const BoxConstraints(minHeight: 70.0), // Adjusted height
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center, // Center vertically within minHeight
                                children: [
                                  // English Text
                                  Text(
                                    segment.englishText,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: hasPlaybackError ? defaultTextColor.withOpacity(0.7) : (isCurrent ? currentTextColor : defaultTextColor),
                                      height: 1.5, // Consistent line height
                                    ),
                                  ),
                                  // Chinese Text (Optional)
                                  if (segment.chineseText.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      segment.chineseText,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: hasPlaybackError ? chineseTextColor.withOpacity(0.7) : (isCurrent ? currentTextColor.withOpacity(0.85) : chineseTextColor),
                                        height: 1.5, // Consistent line height
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }, // End of Consumer builder
                    ); // End of Consumer
                  }, // End of itemBuilder
                ), // End of ScrollablePositionedList

                // --- Error Overlay ---
                // Uses state watched by the main PlayerView build method
                if (hasPlaybackError)
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 40),
                              const SizedBox(height: 10),
                              Text(
                                "Could not load audio: $errorMessage", // Use errorMessage watched above
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // --- Loading Overlay ---
                // Uses state watched by the main PlayerView build method
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  )
              ], // End of Stack children
            ), // End of Stack
          ), // End of Padding
        ), // End of Expanded Transcript Area

        // --- Playback Controls Area ---
        // PlaybackControls will watch the full player state internally
        const PlaybackControls(),

      ], // End of Column children
    ); // End of Column
  } // End of build method
} // End of PlayerView class