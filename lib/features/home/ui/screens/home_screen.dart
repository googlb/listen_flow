import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Use ConsumerWidget
import 'package:go_router/go_router.dart'; // For navigation context.push
// Import the new carousel package
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:listen_flow/features/player/model/listening_material.dart';

// Import providers and models needed by this screen
import '../../providers/home_providers.dart';

// Import the AppRoute enum for navigation path (optional but good practice)
import '../../../../config/router/app_route.dart';


class HomeScreen extends ConsumerWidget { // Use ConsumerWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Get WidgetRef
    // Watch the data providers
    final featuredAsync = ref.watch(featuredMaterialsProvider);
    final allMaterialsAsync = ref.watch(allMaterialsProvider);

    // Use state for the current banner index (optional for carousel_slider_plus)
    // final currentBannerIndex = useState(0); // Less needed with CarouselController

    // Controller for carousel_slider_plus (optional, for programmatic control)
    // final CarouselControllerPlus bannerController = CarouselControllerPlus();

    return Scaffold(
      // AppBar can be part of the ScaffoldWithNavBar or defined here
      // If defined here, it won't be present when navigating within the tab stack
      // If part of ScaffoldWithNavBar, it's always visible for the tab.
      // Let's assume AppBar is suitable here for the Home tab's root.
      appBar: AppBar(
        title: const Text('ListenFlow Home'),
        // Remove elevation if it feels redundant with potential shadow below
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface, // Use theme color
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate providers to trigger a refetch
          ref.invalidate(featuredMaterialsProvider);
          ref.invalidate(allMaterialsProvider);
          // Wait for both fetches to complete before hiding indicator
          // Use '.future' to access the underlying future
          await Future.wait([
            ref.read(featuredMaterialsProvider.future),
            ref.read(allMaterialsProvider.future),
          ]);
        },
        child: ListView( // Use ListView to scroll Banner + List together
          children: [
            // --- Banner Section ---
            featuredAsync.when(
              data: (materials) => _buildBanner(context, materials), // Pass controller if needed
              loading: () => const SizedBox(
                  height: 200, // Adjust height to match banner
                  child: Center(child: CircularProgressIndicator())),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading banner: $error', textAlign: TextAlign.center),
              ),
            ),

            // --- Section Title ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                "Explore All",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            // --- Materials List Section ---
            allMaterialsAsync.when(
              data: (materials) => _buildMaterialList(context, materials),
              // Prevent ListView inside ListView scrolling issues
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator())),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading materials: $error', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 20), // Add some padding at the bottom
          ],
        ),
      ),
    );
  }

  // --- Banner Widget using carousel_slider_plus ---
  Widget _buildBanner(BuildContext context, List<ListeningMaterial> materials) {
     if (materials.isEmpty) {
       return const SizedBox(height: 200, child: Center(child: Text("No featured content."))); // Placeholder
     }

    return Padding(
      // Add vertical padding if desired, less horizontal padding needed if viewportFraction < 1
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.0, // Adjust height as needed
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5), // Adjust interval
          enlargeCenterPage: true, // Make center item larger
          // enlargeFactor: 0.2, // How much larger the center item is
          aspectRatio: 16 / 9, // Common aspect ratio for banners
          viewportFraction: 0.85, // Show parts of adjacent items (0.8 to 0.9 common)
          // onPageChanged: (index, reason) {
          //   // Update state if you need the index elsewhere
          // },
        ),
        items: materials.map((material) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  // Navigate using GoRouter, passing the material object
                   if (material.audioUrl.isNotEmpty) {
                      // Use context.push with the correct path and extra data
                      context.push(AppRoute.detail.path, extra: material);
                   } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Audio not available.'))
                      );
                   }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // Margin between items
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Placeholder background
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: NetworkImage(material.imageUrl),
                      fit: BoxFit.cover,
                      // Handle potential image loading errors gracefully
                      onError: (exception, stackTrace) {
                         debugPrint("Banner Image Error: $exception");
                      },
                    ),
                    boxShadow: [ // Optional subtle shadow
                       BoxShadow(
                         color: Colors.black.withValues(alpha: 0.15),
                         blurRadius: 6,
                         offset: const Offset(0, 3),
                       ),
                    ]
                  ),
                  // Optional: Add an overlay with title if design requires
                  // child: Align(...)
                ),
              );
            },
          );
        }).toList(),
         // controller: bannerController, // Assign controller if needed
      ),
    );
  }

  // --- Material List Widget --- (Remains largely the same)
  Widget _buildMaterialList(BuildContext context, List<ListeningMaterial> materials) {
    if (materials.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(32.0),child: Text("No materials available.")));
    }
    // Use ListView.separated for dividers and better structure than Column
    return ListView.separated(
      itemCount: materials.length,
      shrinkWrap: true, // Important inside another scroll view (the outer ListView)
      physics: const NeverScrollableScrollPhysics(), // Disable its own scrolling
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final material = materials[index];
        return ListTile(
           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
           leading: ClipRRect(
             borderRadius: BorderRadius.circular(8.0),
             child: Image.network(
                material.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                // Placeholder/Error handling for list images
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60, height: 60, color: Colors.grey[200],
                  child: Icon(Icons.broken_image_outlined, color: Colors.grey[400])
                ),
                 loadingBuilder: (context, child, loadingProgress) {
                   if (loadingProgress == null) return child;
                   return Container(
                     width: 60, height: 60, color: Colors.grey[200],
                     child: Center(
                       child: CircularProgressIndicator(
                         strokeWidth: 2.0,
                         value: loadingProgress.expectedTotalBytes != null
                             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                             : null,
                       ),
                     ),
                   );
                 },
              ),
          ),
          title: Text(
             material.title,
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: const TextStyle(fontWeight: FontWeight.w500)
          ),
          subtitle: Text(
            material.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
             // Navigate using GoRouter, passing the material object
             if (material.audioUrl.isNotEmpty) {
               // Use the correct path from your AppRoute enum
                context.push(AppRoute.detail.path, extra: material);
             } else {
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Audio not available for this item.'))
                );
             }
          },
        );
      },
    );
  }
}