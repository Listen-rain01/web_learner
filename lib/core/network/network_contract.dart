/// 描述老系统网络接入的传输约束。
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
