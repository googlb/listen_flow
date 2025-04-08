// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playerHash() => r'0c76a8d8f33fb59d880f79c00ec59c4b907f0b9e';

/// Defines the Player Notifier using Riverpod code generation.
///
/// Manages audio playback state and logic using just_audio, handles user actions,
/// and synchronizes transcript scrolling conditionally based on item visibility.
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
