import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/auth_routes.dart';
import '../../features/home/home_routes.dart';

part 'router.g.dart';

/// 全局路由配置
@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // 各模块类型安全路由（由 go_router_builder 生成）
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

