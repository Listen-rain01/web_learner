import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/user_session_provider.dart';
import '../../features/auth/auth_routes.dart';
import '../../features/auth/presentation/providers/ban_status_provider.dart';
import '../../features/home/home_routes.dart';

part 'router.g.dart';

/// 全局路由配置
@riverpod
GoRouter router(Ref ref) {
  final routerNotifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final user = ref.read(userSessionProvider);
      final isBanned = routerNotifier.isBanned;
      final onLogin = state.matchedLocation == '/login';

      if (user != null && isBanned) {
        ref.read(userSessionProvider.notifier).clear();
        return '/login';
      }
      if (user == null && !onLogin) return '/login';
      return null;
    },
    routes: [
      $homeRoute,
      $loginRoute,
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('页面不存在: ${state.uri}'),
      ),
    ),
  );
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(banStatusProvider, (_, next) {
      isBanned = next.value ?? false;
      notifyListeners();
    });
  }

  final Ref _ref;
  bool isBanned = false;
}
