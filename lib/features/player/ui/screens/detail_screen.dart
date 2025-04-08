import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Use hooks for controllers and effects
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/ui/widgets/player_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'; // For controllers

// Import necessary models, providers, and widgets
import '../../providers/player_provider.dart'; // Access the player notifier/state

/// DetailScreen: Displays the player UI for a specific ListeningMaterial.
///
/// This screen is typically pushed onto the navigation stack (over the main tabs)
/// when a user selects a listening item, for example, from the HomeScreen.
/// It receives the specific [ListeningMaterial] data via GoRouter's `extra` parameter.
class DetailScreen extends HookConsumerWidget {
  /// The specific listening material data to be displayed and played.
  final ListeningMaterial material;

  /// Constructor requiring the [ListeningMaterial].
  const DetailScreen({
    super.key,
    required this.material,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Hooks for Scroll Controllers ---
    // useMemoized ensures these controllers are created only once per widget instance lifecycle.
    final itemScrollController = useMemoized(() => ItemScrollController());
    final itemPositionsListener = useMemoized(() => ItemPositionsListener.create());

    // --- Get Player Notifier ---
    // Use ref.read() to get the notifier instance for calling methods.
    // We don't watch the notifier itself, as its instance rarely changes.
    // The UI will react to state changes via ref.watch(playerProvider) inside PlayerView.
    final playerNotifier = ref.read(playerProvider.notifier);

    // --- Lifecycle Effect for Loading Material ---
    // useEffect handles side effects like loading data when the widget builds
    // or when its dependencies change.
    useEffect(() {
      // This function runs when the effect is first applied or dependencies change.

      // 1. Provide the scroll controller to the player notifier.
      // This allows the notifier to control scrolling the transcript list.
      playerNotifier.setScrollController(itemScrollController);

      // 2. Load the specific material for this screen into the player.
      // It's often good practice to load data after the first frame renders,
      // especially if loading might trigger immediate state changes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure the widget is still mounted before calling async operations
        // that might update state after completion.
        if (context.mounted) {
          playerNotifier.loadMaterial(material);
        }
      });

      // Optional: Return a cleanup function if needed when the effect is disposed
      // (e.g., cancelling something specific to this effect).
      // In this case, the playerProvider's autoDispose handles notifier cleanup.
      return null;

    }, [playerNotifier, itemScrollController, material]);
    // Dependency array: The effect re-runs if any of these objects change identity.
    // This ensures the correct material is loaded if the DetailScreen instance
    // were somehow reused with different material (though less common with `push`).

    // --- Build UI ---
    return Scaffold(
      // AppBar showing the title of the specific material
      appBar: AppBar(
        title: Text(
          material.title, // Display the title from the passed material
          overflow: TextOverflow.ellipsis,
        ),
        // GoRouter automatically adds a back button when pushed onto the root navigator
      ),
      // Body uses the reusable PlayerView widget
      body: PlayerView(
        material: material, // Pass the specific material to the view
        itemScrollController: itemScrollController, // Pass the scroll controller
        itemPositionsListener: itemPositionsListener, // Pass the position listener
      ),
    );
  }
}