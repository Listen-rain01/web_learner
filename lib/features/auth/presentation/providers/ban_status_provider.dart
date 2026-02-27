import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/user_session_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'ban_status_provider.g.dart';

/// 实时监听当前登录用户的禁止状态
/// 仅在用户已登录时订阅，未登录时返回 false
@riverpod
Stream<bool> banStatus(Ref ref) {
  final user = ref.watch(userSessionProvider);
  if (user == null) {
    return Stream.value(false);
  }
  final repo = ref.watch(authRepositoryProvider);
  return repo.watchBanStatus(user.idCard);
}
