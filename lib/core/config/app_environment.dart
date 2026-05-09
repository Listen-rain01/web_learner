enum AppFlavor { development, staging, production }

class AppEnvironment {
  const AppEnvironment({
    required this.appName,
    required this.flavor,
    required this.baseUrl,
  });

  final String appName;
  final AppFlavor flavor;
  final String baseUrl;

  bool get isProduction => flavor == AppFlavor.production;
}
