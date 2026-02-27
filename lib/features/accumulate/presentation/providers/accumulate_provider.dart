import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/user_session_provider.dart';
import '../../data/repositories/accumulate_repository_impl.dart';
import 'accumulate_state.dart';

part 'accumulate_provider.g.dart';

@riverpod
class AccumulateNotifier extends _$AccumulateNotifier {
  @override
  AccumulateState build() {
    _load();
    return const AccumulateState(isLoading: true);
  }

  String get _pid => ref.read(userSessionProvider)?.userId ?? '';

  Future<void> _load() async {
    try {
      final items = await ref
          .read(accumulateRepositoryProvider)
          .getTodayAccumulate(pid: _pid);
      state = state.copyWith(items: items, isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _load();
  }
}
