import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'presentation/pages/login_page.dart';

part 'auth_routes.g.dart';

/// 登录路由
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

