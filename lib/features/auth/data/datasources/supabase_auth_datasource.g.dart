// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseAuthDataSource)
const supabaseAuthDataSourceProvider = SupabaseAuthDataSourceProvider._();

final class SupabaseAuthDataSourceProvider
    extends
        $FunctionalProvider<
          SupabaseAuthDataSource,
          SupabaseAuthDataSource,
          SupabaseAuthDataSource
        >
    with $Provider<SupabaseAuthDataSource> {
  const SupabaseAuthDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseAuthDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseAuthDataSourceHash();

  @$internal
  @override
  $ProviderElement<SupabaseAuthDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupabaseAuthDataSource create(Ref ref) {
    return supabaseAuthDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseAuthDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseAuthDataSource>(value),
    );
  }
}

String _$supabaseAuthDataSourceHash() =>
    r'6341f8a6e530aed7eb4d36448dbecb6d56871056';
