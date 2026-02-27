import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../network/dio_client.dart';
import 'user_session_provider.dart';

part 'home_info_provider.g.dart';

class HomeInfo {
  const HomeInfo({
    required this.userName,
    required this.todayScore,
    required this.currentLibraryName,
  });

  final String userName;
  final String todayScore;
  final String currentLibraryName;
}

@riverpod
class HomeInfoNotifier extends _$HomeInfoNotifier {
  @override
  HomeInfo? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    try {
      final pid = ref.read(userSessionProvider)?.userId ?? '';
      final dio = ref.read(dioClientProvider);
      final response = await dio.post<String>(
        ApiConstants.firstIndexOne,
        data: {'pid': pid},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      );
      final text = response.data ?? '';
      final parts = text.split('|');
      if (parts.length >= 15) {
        state = HomeInfo(
          userName: parts[11],
          todayScore: parts[14],
          currentLibraryName: parts[4].isEmpty ? '未选择题库' : parts[4],
        );
      }
    } catch (_) {
      // 静默失败，不影响主流程
    }
  }

  Future<void> refresh() => _load();
}
