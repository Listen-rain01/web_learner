import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/supabase_constants.dart';

part 'supabase_client.g.dart';

/// anon key 客户端（用于读取：公告、禁止状态检查）
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;

/// service role 客户端（用于写入：upsert 用户记录）
@Riverpod(keepAlive: true)
SupabaseClient supabaseAdminClient(Ref ref) => SupabaseClient(
      SupabaseConstants.supabaseUrl,
      SupabaseConstants.supabaseServiceRoleKey,
    );
