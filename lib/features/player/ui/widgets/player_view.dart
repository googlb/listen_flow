import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Use ConsumerWidget for Riverpod access
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For the transcript list

// Import models, providers, and other necessary widgets
import '../../providers/player_provider.dart'; // Access the player state and notifier
import 'playback_controls.dart'; // The widget for buttons and slider

/// PlayerView: A reusable widget displaying the core player interface.
///
/// This includes the scrollable transcript list synchronized with audio playback
/// and the playback controls section. It reads the player state from Riverpod.
class PlayerView extends ConsumerWidget { // Changed to ConsumerWidget as no hooks are directly used here
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
    // --- Watch Player State ---
    // Listen to the player provider to get the current state.
    // This widget will rebuild whenever the PlayerScreenState changes.
    final playerState = ref.watch(playerProvider);

    // Get the notifier instance once to call methods (like seek).
    // Use ref.read inside callbacks or when the instance itself is needed.
    final playerNotifier = ref.read(playerProvider.notifier);

    // --- Handle Player Loading/Error States ---
    // Display indicators or messages based on the player's internal state.
    // Note: Material loading is typically handled by the parent screen (DetailScreen/ReadingScreen).
    if (playerState.isLoading) {
      // Show a loading indicator while the player is initially setting the audio source.
      return const Center(child: CircularProgressIndicator());
    }

    if (playerState.errorMessage != null) {
      // Display an error message if the player encountered an issue.
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Player Error: ${playerState.errorMessage}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    // --- Build Main Player UI ---
    return Column(
      children: [
        // --- Transcript Area ---
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // Use ScrollablePositionedList for synchronized scrolling
            child: ScrollablePositionedList.builder(
              itemCount: material.transcript.length, // Number of transcript segments
              itemScrollController: itemScrollController, // Controller for programmatic scrolling
              itemPositionsListener: itemPositionsListener, // Listener for visible items
              itemBuilder: (context, index) {
                // Get the specific transcript segment for this index
                final TranscriptSegment segment = material.transcript[index];

                // Determine if this segment is the currently playing one
                final bool isCurrent = index == playerState.currentSegmentIndex;

                // Define text colors for highlighting
                final Color currentTextColor = Theme.of(context).colorScheme.primary;
                final Color defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
                final Color chineseTextColor = Colors.grey[600]!;

                // Make each segment tappable to seek audio
                return InkWell(
                  onTap: () => playerNotifier.seekToSegment(index), // Call notifier method on tap
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0), // Spacing between segments
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                      children: [
                        // English Text
                        Text(
                          segment.englishText,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, // Bold if current
                            color: isCurrent ? currentTextColor : defaultTextColor, // Highlight color if current
                            height: 1.5, // Line spacing
                          ),
                        ),
                        // Chinese Text (Optional)
                        if (segment.chineseText.isNotEmpty) ...[
                          const SizedBox(height: 4), // Small gap between English and Chinese
                          Text(
                            segment.chineseText,
                            style: TextStyle(
                              fontSize: 15,
                              // Slightly less prominent highlight for translation
                              color: isCurrent ? currentTextColor.withOpacity(0.85) : chineseTextColor,
                              height: 1.4, // Line spacing
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // --- Playback Controls Area ---
        // Include the separate PlaybackControls widget.
        // Pass the current player state and the notifier instance to it.
        const PlaybackControls(), 
      ],
    );
  }
}