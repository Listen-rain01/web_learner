import '../../domain/entities/accumulate_entity.dart';

class AccumulateState {
  const AccumulateState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<AccumulateEntity> items;
  final bool isLoading;
  final String? errorMessage;

  int get totalCur => items.fold(0, (sum, e) => sum + e.curAccumulate);
  int get totalMax => items.fold(0, (sum, e) => sum + e.maxAccumulate);

  AccumulateState copyWith({
    List<AccumulateEntity>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AccumulateState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
