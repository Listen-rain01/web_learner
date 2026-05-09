import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/features/auth/data/remote/auth_remote_data_source.dart';
import 'package:web_learner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:web_learner/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    apiClientFactory: ref.watch(apiClientFactoryProvider),
    environment: ref.watch(appEnvironmentProvider),
    requestEncoder: ref.watch(appRequestEncoderProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    sessionCookieStore: ref.watch(sessionCookieStoreProvider),
  );
});
