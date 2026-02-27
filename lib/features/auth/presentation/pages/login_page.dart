import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../announcement/presentation/providers/announcement_provider.dart';
import '../providers/login_provider.dart';

/// 登录页面
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _idCardController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idCardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _idCardFocusNode.addListener(() {
      final notifier = ref.read(loginProvider.notifier);
      if (_idCardFocusNode.hasFocus) {
        notifier.showSuggestions();
      } else {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) notifier.hideSuggestions();
        });
      }
    });
  }

  @override
  void dispose() {
    _idCardController.dispose();
    _passwordController.dispose();
    _idCardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final notifier = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);
    final announcementAsync = ref.watch(announcementProvider);

    // 同步 controller 与 state（选择账号时更新输入框）
    if (_idCardController.text != state.idCard) {
      _idCardController.text = state.idCard;
      _idCardController.selection = TextSelection.collapsed(
        offset: state.idCard.length,
      );
    }
    if (_passwordController.text != state.password) {
      _passwordController.text = state.password;
      _passwordController.selection = TextSelection.collapsed(
        offset: state.password.length,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 公告跑马灯横条（有公告时显示，不可关闭）
            if (announcementAsync.value != null)
              _MarqueeAnnouncement(
                content: announcementAsync.value!.content,
              ),
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
                        AppConstants.appName,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // 身份证输入框 + 下拉账号列表
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _idCardController,
                            focusNode: _idCardFocusNode,
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
                                        _passwordController.clear();
                                        notifier.updateIdCard('');
                                        notifier.updatePassword('');
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: notifier.updateIdCard,
                          ),
                          // 下拉账号建议列表
                          if (state.showAccountSuggestions && state.savedAccounts.isNotEmpty)
                            Material(
                              elevation: 4,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(8),
                              ),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.savedAccounts.length,
                                separatorBuilder: (_, _) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final idCard = state.savedAccounts[index];
                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.person_outline, size: 20),
                                    title: Text(
                                      idCard,
                                      style: textTheme.bodyMedium,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed: () => notifier.removeAccount(idCard),
                                    ),
                                    onTap: () => notifier.selectAccount(idCard),
                                  );
                                },
                              ),
                            ),
                        ],
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
                            onTap: state.isLoading ? null : notifier.toggleRememberAccount,
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
                                child: CircularProgressIndicator(strokeWidth: 2),
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
                              Icon(Icons.error_outline, color: colorScheme.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: TextStyle(color: colorScheme.onErrorContainer),
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
                    '开发者：${AppConstants.developer}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.copyright,
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

/// 跑马灯公告横条
class _MarqueeAnnouncement extends StatefulWidget {
  const _MarqueeAnnouncement({required this.content});

  final String content;

  @override
  State<_MarqueeAnnouncement> createState() => _MarqueeAnnouncementState();
}

class _MarqueeAnnouncementState extends State<_MarqueeAnnouncement>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(_scroll)..repeat();
  }

  void _scroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(max * _controller.value);
  }

  @override
  void dispose() {
    _controller.removeListener(_scroll);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.campaign_outlined,
              size: 18, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                '${widget.content}          ',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
