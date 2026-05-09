import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:web_learner/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
