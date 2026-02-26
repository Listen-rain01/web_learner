// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examRepository)
const examRepositoryProvider = ExamRepositoryProvider._();

final class ExamRepositoryProvider
    extends $FunctionalProvider<ExamRepository, ExamRepository, ExamRepository>
    with $Provider<ExamRepository> {
  const ExamRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExamRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExamRepository create(Ref ref) {
    return examRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamRepository>(value),
    );
  }
}

String _$examRepositoryHash() => r'f929fd5cf12695bfc73b8beec0d885a411769bee';
