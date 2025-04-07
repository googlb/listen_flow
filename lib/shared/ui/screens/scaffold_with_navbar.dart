import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A Scaffold that includes a BottomNavigationBar for navigating between tabs.
/// It uses the provided [NavigationShell] to manage the state and navigation
/// of the different branches (tabs).
class ScaffoldWithNavBar extends StatelessWidget {
  /// The [NavigationShell] supplied by GoRouter's StatefulShellRoute builder.
  /// This object holds the state for each navigation branch (tab) and provides
  /// methods to navigate between them.
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  @override
  Widget build(BuildContext context) {
    // Determine the theme brightness for potential icon/color adjustments
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // The body of the Scaffold displays the current page for the selected tab.
      // The navigationShell widget handles displaying the correct page based
      // on its currentIndex and the routes defined in the corresponding branch.
      body: navigationShell, // <- This widget displays the active page content

      // The BottomNavigationBar allows users to switch between tabs.
      bottomNavigationBar: BottomNavigationBar(
        // Define the items (tabs) for the navigation bar.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icon shown when tab is active
            label: 'Home', // Text label for the tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones_outlined),
            activeIcon: Icon(Icons.headphones),
            label: 'Reading',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],

        // The currently selected tab index. This is managed by the navigationShell.
        currentIndex: navigationShell.currentIndex,

        // Callback when a tab is tapped.
        onTap: (int tappedIndex) => _onTap(context, tappedIndex),

        // Apply theme colors or customize directly
        // selectedItemColor: Theme.of(context).colorScheme.primary,
        // unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        // backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        // showUnselectedLabels: true, // Optional: always show labels

        // Ensure labels are always visible, even with more than 3 items
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Handles navigation when a BottomNavigationBar item is tapped.
  /// It uses the `goBranch` method of the [NavigationShell] to switch to the
  /// corresponding navigation branch (tab).
  ///
  /// The `initialLocation` parameter controls whether tapping the currently
  /// active tab resets its navigation stack. Setting it to true (`index == navigationShell.currentIndex`)
  /// means tapping the active tab will pop all pages in that tab's stack back to its initial route.
  /// Setting it to false would mean tapping the active tab does nothing.
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      // If the user taps the tab they are already on, navigate to the initial location
      // of that tab's branch. This provides a way to "reset" the view within a tab.
      // Set to false if you *don't* want this reset behavior.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}