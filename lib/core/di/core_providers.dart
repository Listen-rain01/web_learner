import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/config/app_environment.dart';
import 'package:web_learner/core/logging/app_logger.dart';
import 'package:web_learner/core/network/api_client_factory.dart';
import 'package:web_learner/core/network/request_encoder.dart';
import 'package:web_learner/core/network/session_cookie_store.dart';
import 'package:web_learner/core/storage/local_kv_store.dart';
import 'package:web_learner/core/storage/secure_kv_store.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return const AppEnvironment(
    appName: 'Web Learner',
    flavor: AppFlavor.development,
    baseUrl: 'http://61.150.84.25:100',
    supabaseUrl: String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://oknsfmaxtvealnmouemj.supabase.co',
    ),
    supabasePublishableKey: String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
      defaultValue: 'sb_publishable_5xz5ri1DAxIivclZwai9AQ_QActvAOH',
    ),
  );
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  return const AppLogger();
});

final localKvStoreProvider = Provider<LocalKvStore>((ref) {
  return LocalKvStore();
});

final secureKvStoreProvider = Provider<SecureKvStore>((ref) {
  return SecureKvStore();
});

final sessionCookieStoreProvider = Provider<SessionCookieStore>((ref) {
  return SessionCookieStore();
});

final appRequestEncoderProvider = Provider<AppRequestEncoder>((ref) {
  return const AppRequestEncoder();
});

final apiClientFactoryProvider = Provider<ApiClientFactory>((ref) {
  return ApiClientFactory(
    environment: ref.watch(appEnvironmentProvider),
    sessionCookieStore: ref.watch(sessionCookieStoreProvider),
  );
});
