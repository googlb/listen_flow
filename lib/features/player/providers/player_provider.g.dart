// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playerHash() => r'975917fcc5e6a9525c3cc5275c5db7b45abcba13';

/// Defines the Player Notifier using Riverpod code generation.
///
/// Manages audio playback state and logic using just_audio, handles user actions,
/// and synchronizes transcript scrolling conditionally based on item visibility,
/// list scroll boundaries, and whether the update was triggered by user interaction
/// or automatic playback progression.
///
/// Copied from [Player].
@ProviderFor(Player)
final playerProvider =
    AutoDisposeNotifierProvider<Player, PlayerScreenState>.internal(
      Player.new,
      name: r'playerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$playerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Player = AutoDisposeNotifier<PlayerScreenState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
