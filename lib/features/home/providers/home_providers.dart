import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';



part 'home_providers.g.dart'; // Riverpod generator file

// Provider for Featured Materials (Banner Data)
@riverpod
Future<List<ListeningMaterial>> featuredMaterials(Ref ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // --- Replace with your actual API call or data fetching logic ---
  return List.generate(
    3,
    (index) => ListeningMaterial(
      id: 'feat_$index',
      title: 'Featured Story ${index + 1}',
      description: 'An interesting featured story description.',
      // Use higher quality images for banner if available
      imageUrl: 'https://via.placeholder.com/600x300/FFA500/FFFFFF?text=Featured+${index + 1}',
      // Ensure a valid audio URL for navigation
      audioUrl: "https://file-examples.com/storage/feaade38c363316396f0f20/2017/11/file_example_MP3_700KB.mp3",
      // Provide sample transcript data (or fetch real data)
      transcript: _getSampleTranscript(),
    ),
  );
}

// Provider for All Listening Materials (List Data)
@riverpod
Future<List<ListeningMaterial>> allMaterials(Ref ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 800));

  // --- Replace with your actual API call or data fetching logic ---
  return List.generate(
    10,
    (index) => ListeningMaterial(
      id: 'item_$index',
      title: 'A Bite of China ${index + 1} - Topic ${index + 1}',
      description: 'Explore the rich culinary culture and natural gifts of China in episode ${index + 1}.',
      imageUrl: 'https://via.placeholder.com/150/4682B4/FFFFFF?text=Topic+${index + 1}',
      audioUrl: "https://file-examples.com/storage/feaade38c363316396f0f20/2017/11/file_example_MP3_700KB.mp3", // Sample URL
      transcript: _getSampleTranscript(),
    ),
  );
}


// --- Helper: Sample Transcript Data --- (Keep this or move to a data source)
List<TranscriptSegment> _getSampleTranscript() {
  return [
     TranscriptSegment(
        englishText: "China has a large population and the richest and most varied natural landscapes in the world.",
        chineseText: "中国拥有众多的人口，也拥有世界上最丰富多元的自然景观。",
        startTime: Duration.zero,
        endTime: Duration(seconds: 7)),
    TranscriptSegment(
        englishText: "Plateaus, forests, lakes, and coastlines...",
        chineseText: "高原、山林、湖、海岸线...",
        startTime: Duration(seconds: 7),
        endTime: Duration(seconds: 18)),
     TranscriptSegment(
        englishText: "No other country has so many potential food sources...",
        chineseText: "任何一个国家都没有中国这样多潜在的食物原材料...",
        startTime: Duration(seconds: 18),
        endTime: Duration(seconds: 24)),
    // ... add more segments or keep it short for sample
  ];
}