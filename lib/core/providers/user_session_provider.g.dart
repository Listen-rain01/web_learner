// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前登录用户的会话状态（keepAlive 防止导航后被销毁）

@ProviderFor(UserSession)
const userSessionProvider = UserSessionProvider._();

/// 当前登录用户的会话状态（keepAlive 防止导航后被销毁）
final class UserSessionProvider
    extends $NotifierProvider<UserSession, UserEntity?> {
  /// 当前登录用户的会话状态（keepAlive 防止导航后被销毁）
  const UserSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSessionHash();

  @$internal
  @override
  UserSession create() => UserSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserEntity? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserEntity?>(value),
    );
  }
}

String _$userSessionHash() => r'12919f02dedab725f3b904434c4072e0b74709bc';

/// 当前登录用户的会话状态（keepAlive 防止导航后被销毁）

abstract class _$UserSession extends $Notifier<UserEntity?> {
  UserEntity? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserEntity?, UserEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserEntity?, UserEntity?>,
              UserEntity?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
