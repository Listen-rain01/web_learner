import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_learner/app/app.dart';

void main() {
  testWidgets('app boots and shows login screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Web Learner'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
