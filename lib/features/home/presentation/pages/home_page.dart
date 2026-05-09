import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_controller.dart';
import '../widgets/home_feature_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const routeName = 'home';
  static const routePath = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace'),
        actions: [
          TextButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current scaffold',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Signed in as ${session?.displayName ?? 'Guest'}. '
                    'This project now has an application layer, a core layer, '
                    'and feature folders ready for real API integration.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Priority features',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const HomeFeatureCard(
            title: 'Auth',
            status: 'Bootstrapped',
            description:
                'Login flow scaffolded with domain, repository, controller and UI boundaries.',
          ),
          const SizedBox(height: 12),
          const HomeFeatureCard(
            title: 'Question Bank',
            status: 'Ready for integration',
            description:
                'Flow placeholders are aligned to unit -> category -> child node -> exam type selection.',
          ),
          const SizedBox(height: 12),
          const HomeFeatureCard(
            title: 'Reading / Check-in / Daily Points',
            status: 'Reserved',
            description:
                'Folders are created so feature code lands in stable locations as the APIs come in.',
          ),
          const SizedBox(height: 12),
          const HomeFeatureCard(
            title: 'Exam Core',
            status: 'Reserved',
            description:
                'Shared entities can live here before mobile-exam and mock-exam implementations diverge.',
          ),
        ],
      ),
    );
  }
}
