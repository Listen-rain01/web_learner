// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accumulate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccumulateNotifier)
const accumulateProvider = AccumulateNotifierProvider._();

final class AccumulateNotifierProvider
    extends $NotifierProvider<AccumulateNotifier, AccumulateState> {
  const AccumulateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accumulateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accumulateNotifierHash();

  @$internal
  @override
  AccumulateNotifier create() => AccumulateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccumulateState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccumulateState>(value),
    );
  }
}

String _$accumulateNotifierHash() =>
    r'97fb215208b5632046120e76623d34d4bd6e2965';

abstract class _$AccumulateNotifier extends $Notifier<AccumulateState> {
  AccumulateState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AccumulateState, AccumulateState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccumulateState, AccumulateState>,
              AccumulateState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
