/// 标识应用当前运行的环境类型。
enum AppFlavor { development, staging, production }

/// 保存启动阶段注入的应用级配置。
class AppEnvironment {
  const AppEnvironment({
    required this.appName,
    required this.flavor,
    required this.baseUrl,
    required this.supabaseUrl,
    required this.supabasePublishableKey,
  });

  final String appName;
  final AppFlavor flavor;
  final String baseUrl;
  final String supabaseUrl;
  final String supabasePublishableKey;

  /// 返回当前构建是否为生产环境。
  bool get isProduction => flavor == AppFlavor.production;

  /// 返回当前构建是否具备启用 Supabase 的条件。
  bool get hasSupabase =>
      supabaseUrl.trim().isNotEmpty && supabasePublishableKey.trim().isNotEmpty;

  /// 返回老系统表单请求需要使用的 Origin。
  String get origin => baseUrl;

  /// 返回老系统登录接口要求的 Referer。
  String get loginReferer => '$baseUrl/Home/LoginWap2';
}
