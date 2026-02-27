// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 实时监听当前登录用户的禁止状态
/// 仅在用户已登录时订阅，未登录时返回 false

@ProviderFor(banStatus)
const banStatusProvider = BanStatusProvider._();

/// 实时监听当前登录用户的禁止状态
/// 仅在用户已登录时订阅，未登录时返回 false

final class BanStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// 实时监听当前登录用户的禁止状态
  /// 仅在用户已登录时订阅，未登录时返回 false
  const BanStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'banStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$banStatusHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return banStatus(ref);
  }
}

String _$banStatusHash() => r'caa44f5ded1cb60dd1eeffb8d795bac93c384920';
