import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_learner/app/app.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/core/storage/local_kv_store.dart';
import 'package:web_learner/core/storage/secure_kv_store.dart';
import 'package:web_learner/core/supabase/supabase_client_provider.dart';

void main() {
  testWidgets('app boots and shows login screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localKvStoreProvider.overrideWithValue(LocalKvStore.memory()),
          secureKvStoreProvider.overrideWithValue(SecureKvStore.memory()),
          supabaseClientProvider.overrideWithValue(null),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Web Learner'), findsOneWidget);
    expect(find.text('登录'), findsOneWidget);
  });
}
