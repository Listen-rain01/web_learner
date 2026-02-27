import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/supabase/supabase_client.dart';

part 'supabase_auth_datasource.g.dart';

/// Supabase 认证数据源
/// 负责禁止登录检查和用户记录
class SupabaseAuthDataSource {
  const SupabaseAuthDataSource(this._client, this._adminClient);

  /// anon client：用于读取（检查禁止状态）
  final SupabaseClient _client;

  /// admin client：用于写入（upsert 用户记录）
  final SupabaseClient _adminClient;

  /// 检查账号是否被禁止登录
  /// 若账号不存在则视为未禁止（首次登录）
  Future<void> checkBanned(String idCard) async {
    final data = await _client
        .from('users')
        .select('is_banned')
        .eq('id_card', idCard)
        .maybeSingle();

    if (data != null && data['is_banned'] == true) {
      throw AppException('账号已被禁止登录，请联系开发者');
    }
  }

  /// 实时订阅指定账号的禁止状态
  /// 管理员在后台修改 is_banned 后立即推送
  Stream<bool> watchBanStatus(String idCard) {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id_card', idCard)
        .map((rows) {
          if (rows.isEmpty) return false;
          return rows.first['is_banned'] == true;
        });
  }

  /// 记录或更新用户登录信息
  /// 失败时静默忽略，不影响主登录流程
  Future<void> upsertUser({
    required String idCard,
    required String name,
  }) async {
    await _adminClient.from('users').upsert({
      'id_card': idCard,
      'name': name,
      'last_login_at': DateTime.now().toIso8601String(),
    }, onConflict: 'id_card');
  }
}

@riverpod
SupabaseAuthDataSource supabaseAuthDataSource(Ref ref) {
  return SupabaseAuthDataSource(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseAdminClientProvider),
  );
}
