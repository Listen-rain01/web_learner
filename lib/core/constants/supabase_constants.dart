/// Supabase 项目配置
/// 请将占位符替换为你的实际 Supabase 项目凭证
class SupabaseConstants {
  SupabaseConstants._();

  /// Supabase 项目 URL
  /// 在 Supabase 控制台 → Settings → API → Project URL 获取
  static const String supabaseUrl = 'https://bqighewpgizlkymwnhdh.supabase.co';

  /// Supabase 匿名公钥（用于读取公告、检查禁止状态）
  /// 在 Supabase 控制台 → Settings → API → anon public 获取
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJxaWdoZXdwZ2l6bGt5bXduaGRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2MDU4OTMsImV4cCI6MjA4MTE4MTg5M30.yNZZ6mAKqYnJwQgc7k5N8x-zDooTtuelVblaOWdxX-8';

  /// Supabase Service Role Key（用于写入用户记录）
  /// 在 Supabase 控制台 → Settings → API → service_role 获取
  /// 注意：此 key 拥有完整权限，不要暴露给前端用户，仅在可信环境使用
  static const String supabaseServiceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJxaWdoZXdwZ2l6bGt5bXduaGRoIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTYwNTg5MywiZXhwIjoyMDgxMTgxODkzfQ.YJz83YSgvhstwFQYrXqZEwQfae-3Dpi01Y604LfR95Y';
}
