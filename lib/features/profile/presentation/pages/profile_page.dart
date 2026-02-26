import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/app_info_provider.dart';
import '../../../../core/providers/user_session_provider.dart';
import '../providers/profile_provider.dart';

/// 我的页面
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final profileState = ref.watch(profileProvider);
    final appInfo = ref.watch(appInfoProvider).asData?.value;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final profile = profileState.profile;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileProvider.notifier).refresh(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 顶部头像区域
            Container(
              color: colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: profileState.photoBytes != null
                        ? MemoryImage(profileState.photoBytes!)
                        : null,
                    child: profileState.photoBytes != null
                        ? null
                        : profileState.isLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimaryContainer,
                              )
                            : Text(
                                user?.userName.isNotEmpty == true
                                    ? user!.userName[0].toUpperCase()
                                    : '?',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile?.pname ?? user?.userName ?? '',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.punit ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 错误提示
            if (profileState.errorMessage != null)
              Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colorScheme.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        profileState.errorMessage!,
                        style: TextStyle(color: colorScheme.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            // 个人信息列表
            Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.badge_outlined,
                    label: '身份证',
                    value: profile?.idcard ?? '加载中...',
                  ),
                  const Divider(height: 1, indent: 56),
                  _InfoTile(
                    icon: Icons.phone_outlined,
                    label: '电话',
                    value: profile == null
                        ? '加载中...'
                        : profile.tel.isEmpty
                            ? '暂未填写'
                            : profile.tel,
                  ),
                  const Divider(height: 1, indent: 56),
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: '地址',
                    value: profile == null
                        ? '加载中...'
                        : profile.address.isEmpty
                            ? '暂未填写'
                            : profile.address,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 更多选项
            Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    title: const Text('反馈与帮助'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('该功能暂未开放')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('关于'),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('关于', textAlign: TextAlign.center),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppConstants.appName),
                              const SizedBox(height: 4),
                              Text('版本 ${appInfo?.version ?? '-'}'),
                              const SizedBox(height: 4),
                              Text('作者 ${AppConstants.developer}'),
                              const SizedBox(height: 8),
                              Text(
                                AppConstants.copyright,
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('确定'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 退出登录
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  ref.read(userSessionProvider.notifier).clear();
                  context.go('/login');
                },
                child: const Text('退出登录'),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: colorScheme.primary),
          const SizedBox(width: 18),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
