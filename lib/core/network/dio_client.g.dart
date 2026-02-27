// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// CookieJar Provider，保持登录 Session Cookie

@ProviderFor(cookieJar)
const cookieJarProvider = CookieJarProvider._();

/// CookieJar Provider，保持登录 Session Cookie

final class CookieJarProvider
    extends $FunctionalProvider<CookieJar, CookieJar, CookieJar>
    with $Provider<CookieJar> {
  /// CookieJar Provider，保持登录 Session Cookie
  const CookieJarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookieJarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookieJarHash();

  @$internal
  @override
  $ProviderElement<CookieJar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CookieJar create(Ref ref) {
    return cookieJar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookieJar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookieJar>(value),
    );
  }
}

String _$cookieJarHash() => r'faac22de9751ccb26d253ff2ac40f660f01b425c';

/// Dio 客户端 Provider

@ProviderFor(dioClient)
const dioClientProvider = DioClientProvider._();

/// Dio 客户端 Provider

final class DioClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio 客户端 Provider
  const DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioClientHash() => r'cce0315e5b73ef97b235a3f81e5e345c3a7a8bc4';
