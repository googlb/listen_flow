import 'package:listen_flow/features/player/model/listening_material.dart';
import 'package:listen_flow/data/sample_transcript_data.dart';

/// Sample listening material about Chinese cuisine
final ListeningMaterial sampleListeningMaterial = ListeningMaterial(
  id: "sample-001",
  title: "Chinese Cuisine and Food Culture",
  description: "An introduction to the diverse culinary traditions of China, including the famous 'Eight Great Cuisines' and the philosophy behind Chinese food culture.",
  imageUrl: "https://example.com/images/chinese-cuisine.jpg",
  audioUrl: "https://example.com/audio/chinese-cuisine.mp3",
  transcript: sampleTranscriptData,
);
