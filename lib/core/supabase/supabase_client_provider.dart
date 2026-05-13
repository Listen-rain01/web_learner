import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_learner/core/di/core_providers.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (!environment.hasSupabase) {
    return null;
  }

  return SupabaseClient(
    environment.supabaseUrl,
    environment.supabasePublishableKey,
  );
});
