import 'dart:typed_data';

import '../../domain/entities/profile_entity.dart';

/// 个人信息页面状态
class ProfileState {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
    this.photoBytes,
  });

  final ProfileEntity? profile;
  final bool isLoading;
  final String? errorMessage;

  /// 头像图片字节（通过 Dio 携带 Cookie 下载）
  final Uint8List? photoBytes;

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    Uint8List? photoBytes,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      photoBytes: photoBytes ?? this.photoBytes,
    );
  }
}
