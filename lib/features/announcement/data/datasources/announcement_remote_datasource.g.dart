// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcementRemoteDataSource)
const announcementRemoteDataSourceProvider =
    AnnouncementRemoteDataSourceProvider._();

final class AnnouncementRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AnnouncementRemoteDataSource,
          AnnouncementRemoteDataSource,
          AnnouncementRemoteDataSource
        >
    with $Provider<AnnouncementRemoteDataSource> {
  const AnnouncementRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AnnouncementRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementRemoteDataSource create(Ref ref) {
    return announcementRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementRemoteDataSource>(value),
    );
  }
}

String _$announcementRemoteDataSourceHash() =>
    r'6f92a2e7bc0d191d16a74f4b1224c89ad24d405e';
