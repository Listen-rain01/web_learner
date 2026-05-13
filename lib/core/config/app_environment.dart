enum AppFlavor { development, staging, production }

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

  bool get isProduction => flavor == AppFlavor.production;
  bool get hasSupabase =>
      supabaseUrl.trim().isNotEmpty &&
      supabasePublishableKey.trim().isNotEmpty;

  String get origin => baseUrl;

  String get loginReferer => '$baseUrl/Home/LoginWap2';
}
