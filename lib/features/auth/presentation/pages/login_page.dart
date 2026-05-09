import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/auth/application/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const routeName = 'login';
  static const routePath = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static const _appName = 'Web Learner';
  static const _developer = '开发者：山归有时雾';
  static const _copyright = 'Copyright © 2026 Web Learner';

  final _formKey = GlobalKey<FormState>();
  final _idCardController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idCardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _idCardFocusNode.addListener(_handleIdCardFocusChange);
  }

  @override
  void dispose() {
    _idCardFocusNode.removeListener(_handleIdCardFocusChange);
    _idCardController.dispose();
    _passwordController.dispose();
    _idCardFocusNode.dispose();
    super.dispose();
  }

  void _handleIdCardFocusChange() {
    final notifier = ref.read(authControllerProvider.notifier);
    if (_idCardFocusNode.hasFocus) {
      notifier.showAccountSuggestions();
      return;
    }

    Future<void>.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        notifier.hideAccountSuggestions();
      }
    });
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    await ref.read(authControllerProvider.notifier).signIn(
          account: _idCardController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FlutterLogo(size: 88),
                        const SizedBox(height: 18),
                        Text(
                          _appName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _idCardController,
                                focusNode: _idCardFocusNode,
                                enabled: !authState.isSubmitting,
                                decoration: InputDecoration(
                                  labelText: '身份证号',
                                  hintText: '请输入您的身份证号码',
                                  prefixIcon: const Icon(Icons.badge_outlined),
                                  suffixIcon: _idCardController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            _idCardController.clear();
                                            _passwordController.clear();
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.clear),
                                        ),
                                ),
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => setState(() {}),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '请输入身份证号';
                                  }
                                  return null;
                                },
                              ),
                              if (authState.showAccountSuggestions &&
                                  authState.savedAccounts.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Material(
                                  elevation: 6,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 220,
                                    ),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: authState.savedAccounts.length,
                                      separatorBuilder: (_, _) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final account =
                                            authState.savedAccounts[index];

                                        return ListTile(
                                          dense: true,
                                          leading: const Icon(
                                            Icons.person_outline,
                                            size: 20,
                                          ),
                                          title: Text(account.idCard),
                                          trailing: IconButton(
                                            onPressed: () {
                                              unawaited(
                                                notifier.removeAccount(
                                                  account.idCard,
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                          ),
                                          onTap: () {
                                            final credential =
                                                notifier.selectAccount(
                                              account.idCard,
                                            );
                                            _idCardController.text =
                                                account.idCard;
                                            _idCardController.selection =
                                                TextSelection.collapsed(
                                              offset: account.idCard.length,
                                            );
                                            _passwordController.text =
                                                credential?.password ?? '';
                                            _passwordController.selection =
                                                TextSelection.collapsed(
                                              offset:
                                                  _passwordController.text.length,
                                            );
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                enabled: !authState.isSubmitting,
                                obscureText: !authState.showPassword,
                                decoration: InputDecoration(
                                  labelText: '密码',
                                  hintText: '请输入密码',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed:
                                        notifier.togglePasswordVisibility,
                                    icon: Icon(
                                      authState.showPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                onFieldSubmitted: (_) => unawaited(_submit()),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入密码';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: authState.rememberAccount,
                                onChanged: authState.isSubmitting
                                    ? null
                                    : (_) => notifier.toggleRememberAccount(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: authState.isSubmitting
                                  ? null
                                  : notifier.toggleRememberAccount,
                              child: Text(
                                '记住账号和密码',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authState.isSubmitting
                                ? null
                                : () => unawaited(_submit()),
                            child: authState.isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    '登录',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        if (authState.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authState.errorMessage!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Text(
                    _developer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _copyright,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
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
