// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeInfoNotifier)
const homeInfoProvider = HomeInfoNotifierProvider._();

final class HomeInfoNotifierProvider
    extends $NotifierProvider<HomeInfoNotifier, HomeInfo?> {
  const HomeInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeInfoNotifierHash();

  @$internal
  @override
  HomeInfoNotifier create() => HomeInfoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeInfo? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeInfo?>(value),
    );
  }
}

String _$homeInfoNotifierHash() => r'fad97cc44d0a0c5fb3ebccd1acd72816ccca57ac';

abstract class _$HomeInfoNotifier extends $Notifier<HomeInfo?> {
  HomeInfo? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeInfo?, HomeInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeInfo?, HomeInfo?>,
              HomeInfo?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
