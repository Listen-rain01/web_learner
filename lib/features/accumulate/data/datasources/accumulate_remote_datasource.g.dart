// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accumulate_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accumulateRemoteDataSource)
const accumulateRemoteDataSourceProvider =
    AccumulateRemoteDataSourceProvider._();

final class AccumulateRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AccumulateRemoteDataSource,
          AccumulateRemoteDataSource,
          AccumulateRemoteDataSource
        >
    with $Provider<AccumulateRemoteDataSource> {
  const AccumulateRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accumulateRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accumulateRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AccumulateRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccumulateRemoteDataSource create(Ref ref) {
    return accumulateRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccumulateRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccumulateRemoteDataSource>(value),
    );
  }
}

String _$accumulateRemoteDataSourceHash() =>
    r'cad997458bfc150c805e279a332f9440dcda6a98';
