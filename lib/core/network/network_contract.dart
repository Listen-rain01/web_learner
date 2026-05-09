class NetworkContract {
  const NetworkContract({
    required this.usesCookieSession,
    required this.requiresFormEncoding,
    required this.usesHtmlPayloads,
  });

  final bool usesCookieSession;
  final bool requiresFormEncoding;
  final bool usesHtmlPayloads;
}
