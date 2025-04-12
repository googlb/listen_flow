import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';
import 'package:listen_flow/data/sample_transcript_data.dart';
import 'package:listen_flow/data/sample_listening_material.dart';
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
      audioUrl: "https://nc-cdn.oss-us-west-1.aliyuncs.com/notegpt/web3in1/audio/98d409e1-a90c-431b-bbbe-6f24fecd23ba.wav",
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
      title: 'A Bite of China ${index + 1} - Topic ${Random().nextInt(10)} ',
      description: 'Explore the rich culinary culture and natural gifts of China in episode ${index + 1}.',
      imageUrl: 'https://picsum.photos/200/200?text=Topic+${Random().nextInt(10)}',
      audioUrl: "https://easylink.cc/o4keqc", // Sample URL
      transcript: _getSampleTranscript(),
    ),
  );
}


// --- Helper: Sample Transcript Data ---
List<TranscriptSegment> _getSampleTranscript() {
  // Use the comprehensive sample transcript data
  return generatedTranscriptData;
}

// Provider for the sample listening material
@riverpod
ListeningMaterial sampleMaterial(Ref ref) {
  return sampleListeningMaterial;
}
