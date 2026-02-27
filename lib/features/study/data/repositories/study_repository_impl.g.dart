// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(studyRepository)
const studyRepositoryProvider = StudyRepositoryProvider._();

final class StudyRepositoryProvider
    extends
        $FunctionalProvider<StudyRepository, StudyRepository, StudyRepository>
    with $Provider<StudyRepository> {
  const StudyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyRepositoryHash();

  @$internal
  @override
  $ProviderElement<StudyRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StudyRepository create(Ref ref) {
    return studyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudyRepository>(value),
    );
  }
}

String _$studyRepositoryHash() => r'f725582c0aa972838d47666f01809b3f626db7cf';
