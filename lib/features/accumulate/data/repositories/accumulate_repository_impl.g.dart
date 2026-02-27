// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accumulate_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accumulateRepository)
const accumulateRepositoryProvider = AccumulateRepositoryProvider._();

final class AccumulateRepositoryProvider
    extends
        $FunctionalProvider<
          AccumulateRepository,
          AccumulateRepository,
          AccumulateRepository
        >
    with $Provider<AccumulateRepository> {
  const AccumulateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accumulateRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accumulateRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccumulateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccumulateRepository create(Ref ref) {
    return accumulateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccumulateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccumulateRepository>(value),
    );
  }
}

String _$accumulateRepositoryHash() =>
    r'8b9e7c1707fbf3d2c049cfffd34e8c6108b388fb';
