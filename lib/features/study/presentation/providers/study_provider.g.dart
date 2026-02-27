// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StudyNotifier)
const studyProvider = StudyNotifierProvider._();

final class StudyNotifierProvider
    extends $NotifierProvider<StudyNotifier, StudyState> {
  const StudyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyNotifierHash();

  @$internal
  @override
  StudyNotifier create() => StudyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudyState>(value),
    );
  }
}

String _$studyNotifierHash() => r'3cb94bd7f67f18071a89c18859735240b8249253';

abstract class _$StudyNotifier extends $Notifier<StudyState> {
  StudyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StudyState, StudyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StudyState, StudyState>,
              StudyState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
