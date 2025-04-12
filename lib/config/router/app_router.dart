import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // For Ref in Observer
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/reading/ui/screens/reading_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import your screens and models
import '../../features/home/ui/screens/home_screen.dart';
import '../../features/profile/ui/screens/profile_screen.dart';
import '../../features/player/ui/screens/detail_screen.dart';
import '../../shared/ui/screens/scaffold_with_navbar.dart';
import 'app_route.dart'; // Import your AppRoute enum

// Generated file
part 'app_router.g.dart';

// Keep Navigator Keys
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKeyHome =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorKeyReading =
    GlobalKey<NavigatorState>(debugLabel: 'shellReading');
final GlobalKey<NavigatorState> _shellNavigatorKeyProfile =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

// Define the router provider using the riverpod generator
@riverpod // Keep router alive for the app's lifetime
GoRouter router(Ref ref) { // Generator provides 'ref' automatically
  // Listen to authentication state or other providers if needed for redirects
  // final loggedIn = ref.watch(authNotifierProvider); // Example

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.home.path, // Start at home tab
    debugLogDiagnostics: true, // Enable for development debugging

    // Add observers if needed
    observers: [
      GoRouterObserver(ref), // Pass ref if observer needs it
      // SystemNavObserver(), // Add if you need system UI changes
    ],

    routes: [
      // --- Application Shell ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // The widget that builds the navigation bar and hosts the pages
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },

        branches: [
          // --- Home Tab ---
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyHome,
            routes: [
              GoRoute(
                path: AppRoute.home.path, // '/'
                name: AppRoute.home.name, // 'home'
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
                // Nested routes *within* the home tab (rarely needed with Shell)
                // routes: [ ... ]
              ),
            ],
          ),

          // --- Reading Tab ---
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyReading,
            routes: [
              GoRoute(
                path: AppRoute.reading.path, // '/reading'
                name: AppRoute.reading.name, // 'reading'
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ReadingScreen(),
                ),
              ),
            ],
          ),

           // --- Profile Tab ---
           StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyProfile,
            routes: [
              GoRoute(
                path: AppRoute.profile.path, // '/profile'
                name: AppRoute.profile.name, // 'profile'
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

       // --- Top-Level Routes (Pushed ON TOP of the shell) ---
       GoRoute(
        path: AppRoute.detail.path, // '/detail'
        name: AppRoute.detail.name, // 'detail'
        // Use parentNavigatorKey to ensure it covers the bottom nav bar
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
           // Use your ListeningMaterial model here
          final material = state.extra as ListeningMaterial?;
          if (material == null) {
            // Handle error appropriately - maybe redirect or show error page
             return const Scaffold(body: Center(child: Text('Error: Material Missing')));
          }
          return DetailScreen(material: material);
        },
      ),

    ],

    // --- Redirect Logic ---
    redirect: (context, state) {
      // Example: Redirect logic (e.g., for onboarding, auth later)
      // final bool loggedIn = ref.read(authNotifierProvider); // Use read for redirect
      // final bool isOnboardingComplete = ref.read(onboardingNotifierProvider);
      // final bool goingToLogin = state.matchedLocation == AppRoute.login.path; // Example

      // if (!isOnboardingComplete) {
      //   return AppRoute.onboarding.path; // Redirect to onboarding if not complete
      // }

      // Add authentication logic here if needed later, similar to your previous app
      // if (!loggedIn && !goingToLogin) { ... return AppRoute.login.path }

      // No redirection needed for now
      return null;
    },
  );
}

// --- Observers (Keep or adapt as needed) ---

// Example Observer needing Ref
class GoRouterObserver extends NavigatorObserver {
  final Ref ref;
  GoRouterObserver(this.ref); // Constructor takes Ref

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
     debugPrint('GoRouterObserver: Pushed route: ${route.settings.name}');
     // Add logic using 'ref' if needed
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('GoRouterObserver: Popped route: ${route.settings.name}, back to ${previousRoute?.settings.name}');
    // Your previous logic to refresh data on pop could go here, adapted for ListenFlow
    // Example:
    // if (previousRoute?.settings.name == AppRoute.home.name) {
    //   // Potentially refresh home screen data
    // }
    super.didPop(route, previousRoute);
  }
}

// Example Observer for System UI (Doesn't need Ref)
class SystemNavObserver extends NavigatorObserver {
   @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
     _setNavBarColor(route);
     super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
     _setNavBarColor(previousRoute);
     super.didPop(route, previousRoute);
  }

   void _setNavBarColor(Route<dynamic>? route) {
    // Simplified example: make nav bar slightly different on detail screen
     final routeName = route?.settings.name;
     Color navBarColor = Colors.white; // Default color (adjust for theme)

     if (routeName == AppRoute.detail.name) {
        navBarColor = Colors.grey[200]!; // Different color for detail
     }

     // Consider dark mode as well
     // final brightness = MediaQuery.platformBrightnessOf(navigator!.context);
     // if (brightness == Brightness.dark) { ... adjust colors ... }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navBarColor,
      systemNavigationBarIconBrightness: Brightness.dark, // Or Brightness.light based on navBarColor
    ));
  }
}