import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // For useMemoized, useState, useEffect
import 'package:hooks_riverpod/hooks_riverpod.dart'; // For HookConsumerWidget and ref
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:listen_flow/features/player/providers/player_provider.dart';
import 'package:listen_flow/features/player/ui/widgets/player_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For controllers

// Import necessary models, providers, and the reusable player view

/// ReadingScreen: Represents the "Reading" tab in the application.
///
/// Displays the shared [PlayerView]. It's responsible for loading a
/// default or potentially user-selected listening material into the
/// shared player state when this tab is active.
class ReadingScreen extends HookConsumerWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  // --- Placeholder Data ---
  // TODO: Replace this with actual logic to load the desired material
  // This could involve:
  // - Loading the last played material from storage/state.
  // - Loading a specific "featured" reading material.
  // - Providing a UI within this screen to select material (more complex).
  static final ListeningMaterial _placeholderMaterial = ListeningMaterial(
    id: 'reading_placeholder',
    title: 'Reading Section', // Title shown in AppBar
    description: 'Select material from Home or implement loading logic.',
    // Provide a valid audio URL. A short silent track is ideal if no default content exists.
    // Ensure this URL works or handle potential loading errors gracefully.
    audioUrl: "https://file-examples.com/storage/feaade38c363316396f0f20/2017/11/file_example_MP3_700KB.mp3", // Replace!
    imageUrl: 'https://via.placeholder.com/150/777777/FFFFFF?text=Reading', // Placeholder image
    // Provide a minimal transcript for the placeholder state
    transcript:  [
      TranscriptSegment(englishText: "Welcome to the Reading section.", chineseText: "欢迎来到阅读区。", startTime: Duration.zero, endTime: Duration(seconds: 4)),
      TranscriptSegment(englishText: "Audio controls are below.", chineseText: "音频控件在下方。", startTime: Duration(seconds: 4), endTime: Duration(seconds: 8)),
      // Add more segments if your placeholder audio has more content
    ],
  );
  // --- End Placeholder Data ---

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Hooks for Scroll Controllers ---
    // Create scroll controllers only once using useMemoized.
    final itemScrollController = useMemoized(() => ItemScrollController());
    final itemPositionsListener = useMemoized(() => ItemPositionsListener.create());

    // --- Get Player Notifier ---
    // Get the notifier instance to call methods like loadMaterial.
    final playerNotifier = ref.read(playerProvider.notifier);

    // --- State for Initial Load Tracking ---
    // Use useState to track if the initial material load for this screen instance
    // has been attempted. This prevents reloading every time the widget rebuilds
    // for other reasons (like player state updates).
    final isInitialLoadTriggered = useState(false);

    // --- Effect for Initial Material Load and Controller Setup ---
    // useEffect runs side effects like data loading.
    useEffect(() {
      // Only trigger the load logic once per screen instance lifecycle.
      if (!isInitialLoadTriggered.value) {
        // Mark that we are attempting the load now.
        isInitialLoadTriggered.value = true;

        // 1. Set the scroll controller reference in the notifier.
        playerNotifier.setScrollController(itemScrollController);

        // 2. Load the default/placeholder material into the player.
        // Use addPostFrameCallback to ensure it runs after the first build.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Check if the widget is still mounted before calling async load
          if (context.mounted) {
            debugPrint("ReadingScreen: Loading placeholder material.");
            // Initiate loading but don't necessarily wait here, as the
            // PlayerView will show its own loading state based on the provider.
            playerNotifier.loadMaterial(_placeholderMaterial);
          }
        });
      }

      // No specific cleanup needed here, as the playerProvider handles its own disposal.
      return null;
    }, [playerNotifier, itemScrollController]); // Dependencies: Rerun if these change identity

    // --- Watch Player State for Loading/Error ---
    // We watch the provider state here *mainly* to decide whether to show
    // the PlayerView or a general loading/error indicator *before* the
    // PlayerView itself might handle the player's internal loading state.
    final playerState = ref.watch(playerProvider);

    // --- Build UI ---
    return Scaffold(
      appBar: AppBar(
        // Title for the Reading tab screen
        title: Text(_placeholderMaterial.title),
        // Prevent the back button that might appear due to nested navigators
        automaticallyImplyLeading: false,
         // TODO: Add button/logic here later to select different reading materials
         // actions: [ IconButton(onPressed: () {}, icon: Icon(Icons.list)) ]
      ),
      // Use the shared PlayerView widget.
      // Conditionally render based on whether the initial load attempt has finished
      // or if there's a general error from the player state.
      body: Builder( // Use Builder to provide context if needed inside conditions
        builder: (context) {
           // Show main PlayerView if not in an initial loading state *managed by PlayerView*
           // or if there is no general error. PlayerView handles its own specific loading/error.
           // The isInitialLoadTriggered hook mainly prevents *re-triggering* the load.
          if (playerState.errorMessage != null && !playerState.isLoading) {
             // Show error if player has an error (and isn't actively loading)
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
          // Pass controllers and the determined material to the PlayerView
          return PlayerView(
            material: _placeholderMaterial, // Use the defined material
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          );
           // Note: The PlayerView itself contains another check for playerState.isLoading
           // to show its internal loading indicator while the audio source loads/buffers.
        },
      ),
    );
  }
}