import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/question_bank/presentation/pages/question_bank_page.dart';
import '../../features/shell/presentation/pages/app_shell_page.dart';

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

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref) {
    _subscription = _ref.listen(authControllerProvider, (_, next) {
      if (_lastAuthenticated != next.isAuthenticated) {
        _lastAuthenticated = next.isAuthenticated;
        notifyListeners();
      }
    }, fireImmediately: true);
  }

  final Ref _ref;
  late final ProviderSubscription _subscription;
  bool _lastAuthenticated = false;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
