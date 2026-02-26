import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/login_provider.dart';

/// 登录页面
/// 包含：Logo、应用名称、身份证输入、密码输入、记住账号、登录按钮、版权信息
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _idCardController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _idCardController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final notifier = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      const FlutterLogo(size: 80),
                      const SizedBox(height: 16),

                      // 应用名称
                      Text(
                        'Web Learner',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // 身份证输入框
                      TextFormField(
                        controller: _idCardController,
                        enabled: !state.isLoading,
                        decoration: InputDecoration(
                          labelText: '身份证号',
                          hintText: '请输入您的身份证号码',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          errorText: state.idCardError,
                          suffixIcon: _idCardController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _idCardController.clear();
                                    notifier.updateIdCard('');
                                  },
                                )
                              : null,
                        ),
                        onChanged: notifier.updateIdCard,
                      ),

                      const SizedBox(height: 16),

                      // 密码输入框
                      TextFormField(
                        controller: _passwordController,
                        enabled: !state.isLoading,
                        obscureText: !state.showPassword,
                        decoration: InputDecoration(
                          labelText: '密码',
                          hintText: '请输入密码',
                          prefixIcon: const Icon(Icons.lock_outline),
                          errorText: state.passwordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: notifier.togglePasswordVisibility,
                          ),
                        ),
                        onChanged: notifier.updatePassword,
                      ),

                      const SizedBox(height: 12),

                      // 记住账号
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: state.rememberAccount,
                              onChanged: state.isLoading
                                  ? null
                                  : (_) => notifier.toggleRememberAccount(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: state.isLoading
                                ? null
                                : notifier.toggleRememberAccount,
                            child: Text(
                              '记住账号',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // 登录按钮
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                final success = await notifier.login();
                                if (success && context.mounted) {
                                  context.go('/home');
                                }
                              },
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                '登 录',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      ),

                      // 错误信息提示
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: TextStyle(
                                    color: colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // 底部版权信息
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    '开发者：山归有时雾',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2025 Copyright Web Learner. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
