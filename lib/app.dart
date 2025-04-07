import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import your GoRouter provider and Theme configuration
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart'; // Assuming you have this file

// Your root application widget
class MyApp extends ConsumerWidget {
  // Use const constructor with super.key
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the goRouterProvider. This widget will rebuild if the router
    // instance somehow changes (though usually it doesn't after initial creation).
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      // === Router Configuration ===
      // Provide the GoRouter instance to MaterialApp.router
      routerConfig: goRouter,

      // === App Meta Configuration ===
      title: 'ListenFlow', // Replace with your final app name
      debugShowCheckedModeBanner: false, // Hide debug banner in release

      // === Theming ===
      theme: AppTheme.lightTheme, // Define your light theme in config/theme/
      // Optional: Define and add dark theme
      // darkTheme: AppTheme.darkTheme,
      // Optional: Set theme mode (system, light, dark)
      // themeMode: ThemeMode.system,

      // Add any other global MaterialApp configurations here
      // e.g., builder for setting text scale factor, scroll behavior, etc.
      // builder: (context, child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //     child: child!,
      //   );
      // },
    );
  }
}


