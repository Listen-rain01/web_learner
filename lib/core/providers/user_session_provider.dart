import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/user_entity.dart';

part 'user_session_provider.g.dart';

/// 当前登录用户的会话状态（keepAlive 防止导航后被销毁）
@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  UserEntity? build() => null;

  void setUser(UserEntity user) => state = user;
  void clear() => state = null;
}
