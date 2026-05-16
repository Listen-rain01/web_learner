import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_learner/features/auth/application/auth_controller.dart';
import 'package:web_learner/features/auth/application/auth_state.dart';
import 'package:web_learner/features/auth/presentation/pages/login_page.dart';
import 'package:web_learner/features/home/presentation/pages/home_page.dart';
import 'package:web_learner/features/profile/presentation/pages/profile_page.dart';
import 'package:web_learner/features/question_bank/presentation/pages/question_bank_page.dart';
import 'package:web_learner/features/shell/presentation/pages/app_shell_page.dart';

/// 构建应用路由与登录态重定向规则。
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: LoginPage.routePath,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == LoginPage.routePath;

      if (!isLoggedIn && !isLoginRoute) {
        return LoginPage.routePath;
      }

      if (isLoggedIn && isLoginRoute) {
        return HomePage.routePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.routePath,
                name: HomePage.routeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: QuestionBankPage.routePath,
                name: QuestionBankPage.routeName,
                builder: (context, state) => const QuestionBankPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// 仅在登录状态实际变化时刷新 `GoRouter`。
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref) {
    _subscription = _ref.listen<AuthState>(authControllerProvider, (_, next) {
      if (_lastAuthenticated != next.isAuthenticated) {
        _lastAuthenticated = next.isAuthenticated;
        notifyListeners();
      }
    }, fireImmediately: true);
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _subscription;
  bool _lastAuthenticated = false;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
