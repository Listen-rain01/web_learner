// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcement)
const announcementProvider = AnnouncementProvider._();

final class AnnouncementProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnnouncementEntity?>,
          AnnouncementEntity?,
          Stream<AnnouncementEntity?>
        >
    with
        $FutureModifier<AnnouncementEntity?>,
        $StreamProvider<AnnouncementEntity?> {
  const AnnouncementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementHash();

  @$internal
  @override
  $StreamProviderElement<AnnouncementEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AnnouncementEntity?> create(Ref ref) {
    return announcement(ref);
  }
}

String _$announcementHash() => r'66be62158477886a75b88b8efdca06f66587f694';
