// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playerHash() => r'54a9abee53e22e84bcb01df43e28139485dce861';

/// Defines the Player Notifier using Riverpod code generation.
///
/// This manages the state ([PlayerScreenState]) and logic for the audio player,
/// interacting with `just_audio`, handling user actions, and syncing transcripts.
/// The `keepAlive` parameter determines if the state is preserved (`true`)
/// or disposed when unused (`false`, equivalent to autoDispose).
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
