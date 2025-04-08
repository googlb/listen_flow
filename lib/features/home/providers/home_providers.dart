import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';



part 'home_providers.g.dart'; // Riverpod generator file


const List<String> _featuredImageUrls = [
  'https://cdn.pixabay.com/photo/2017/09/21/13/32/girl-2771936_1280.jpg',
  'https://cdn.pixabay.com/photo/2020/04/28/18/33/key-5105878_640.jpg',
  'https://media.istockphoto.com/id/1322324675/photo/happy-group-of-couple-of-teens-hanging-out-in-the-city.jpg?s=612x612&w=0&k=20&c=zCxXtPHaLzt5txcXtljlTosCbL2xgffPwcctVupnFPc=',
  // Add more URLs if needed
];

// Provider for Featured Materials (Banner Data)
@riverpod
Future<List<ListeningMaterial>> featuredMaterials(Ref ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  // --- Replace with your actual API call or data fetching logic ---
  const int featuredCount = 3;
  return List.generate(
    featuredCount,
    (index) {
      final imageUrl = _featuredImageUrls[index % _featuredImageUrls.length];
      var listeningMaterial = ListeningMaterial(
      id: 'feat_$index',
      title: 'Featured Story ${index + 1}',
      description: 'An interesting featured story description.',
      // Use higher quality images for banner if available
      imageUrl: imageUrl,
      // Ensure a valid audio URL for navigation
      audioUrl: "https://file-examples.com/storage/feaade38c363316396f0f20/2017/11/file_example_MP3_700KB.mp3",
      // Provide sample transcript data (or fetch real data)
      transcript: _getSampleTranscript(),
    );
      return listeningMaterial;
    },
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
      imageUrl: 'https://picsum.photos/200/200?text=Topic+${index + 1}',
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