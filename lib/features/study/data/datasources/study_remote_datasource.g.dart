// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(studyRemoteDataSource)
const studyRemoteDataSourceProvider = StudyRemoteDataSourceProvider._();

final class StudyRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          StudyRemoteDataSource,
          StudyRemoteDataSource,
          StudyRemoteDataSource
        >
    with $Provider<StudyRemoteDataSource> {
  const StudyRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<StudyRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StudyRemoteDataSource create(Ref ref) {
    return studyRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudyRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudyRemoteDataSource>(value),
    );
  }
}

String _$studyRemoteDataSourceHash() =>
    r'1290d4a05de1768afadf244459852c9f1e45c1de';
