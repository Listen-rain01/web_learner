import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/auth/application/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const routeName = 'profile';
  static const routePath = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: const Text('User ID'),
              subtitle: Text(session?.userId ?? 'No active session'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Display name'),
              subtitle: Text(session?.displayName ?? 'No active session'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              title: Text('Module status'),
              subtitle: Text(
                'Profile is reserved for personal info, progress summary, and current exam context.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
