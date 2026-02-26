import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/user_session_provider.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    _loadProfile();
    return const ProfileState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    final user = ref.read(userSessionProvider);
    if (user == null) return;

    try {
      final useCase = GetProfileUseCase(ref.read(profileRepositoryProvider));
      final profile = await useCase(userId: user.userId);
      state = state.copyWith(profile: profile, isLoading: false, clearError: true);

      // 下载头像（携带 Cookie，不影响主流程）
      _loadPhoto(profile.photoUrl);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> _loadPhoto(String photoUrl) async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get<List<int>>(
        photoUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data != null) {
        state = state.copyWith(photoBytes: Uint8List.fromList(response.data!));
      }
    } catch (_) {
      // 头像加载失败静默忽略
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadProfile();
  }
}
