import 'package:flutter_test/flutter_test.dart';
import 'package:web_learner/core/errors/app_exception.dart';
import 'package:web_learner/features/auth/data/repositories/mock_auth_repository.dart';

void main() {
  group('MockAuthRepository', () {
    test('creates a session for valid credentials', () async {
      final repository = MockAuthRepository();

      final session = await repository.signIn(
        account: '123456789012345678',
        password: 'secret',
      );

      expect(session.userId, '123456789012345678');
      expect(session.displayName, 'Learner 5678');
      expect(repository.currentSession, isNotNull);
    });

    test('throws when account or password is empty', () async {
      final repository = MockAuthRepository();

      expect(
        () => repository.signIn(account: '', password: 'secret'),
        throwsA(isA<AppException>()),
      );
      expect(
        () => repository.signIn(account: 'abc', password: ''),
        throwsA(isA<AppException>()),
      );
    });

    test('clears session on sign out', () async {
      final repository = MockAuthRepository();

      await repository.signIn(account: 'account', password: 'secret');
      await repository.signOut();

      expect(repository.currentSession, isNull);
    });
  });
}
