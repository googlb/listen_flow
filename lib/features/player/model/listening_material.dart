
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_flow/features/player/model/transcript_segment.dart';

part 'listening_material.freezed.dart';
part 'listening_material.g.dart';


@freezed
abstract class ListeningMaterial with _$ListeningMaterial {

  factory ListeningMaterial({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String audioUrl,
    required List<TranscriptSegment> transcript,
  }) = _ListeningMaterial;

  factory ListeningMaterial.fromJson(Map<String, dynamic> json) => _$ListeningMaterialFromJson(json);
  
 
}