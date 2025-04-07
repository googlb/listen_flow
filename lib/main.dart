import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import the root application widget
import 'app.dart';

// Optional: If you implement background audio later with audio_service
// import 'package:audio_service/audio_service.dart';
// import 'features/player/data/audio_handler.dart'; // Your background audio handler

// Global variable for background audio handler (if using audio_service)
// late AudioHandler _audioHandler;

Future<void> main() async {
  // Ensure Flutter bindings are initialized. Crucial for async operations
  // before runApp, like setting up background services or loading prefs.
  WidgetsFlutterBinding.ensureInitialized();

  // ---- Optional: Setup for audio_service (Background Audio) ----
  // Uncomment this block if/when you add background audio support
  /*
  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(), // Replace with your AudioHandler implementation
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.yourappdomain.listen_flow.audio', // Unique ID
      androidNotificationChannelName: 'ListenFlow Audio Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true, // Or false if you want controls while paused
    ),
  );
  */
  // ---- End Optional audio_service Setup ----


  runApp(
    // Wrap your entire application in a ProviderScope.
    // This makes all Riverpod providers available throughout the widget tree.
    const ProviderScope(
      child: MyApp(), // Your root application widget from app.dart
    ),
  );
}