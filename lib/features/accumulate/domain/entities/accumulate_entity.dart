/// 积分任务实体
class AccumulateEntity {
  const AccumulateEntity({
    required this.accumulateId,
    required this.accumulateName,
    required this.accumulateRule,
    required this.accumulate,
    required this.maxAccumulate,
    required this.curAccumulate,
    required this.curAccumulateState,
    required this.criterion,
    required this.sort,
    required this.accumulateTypeName,
  });

  final String accumulateId;
  final String accumulateName;
  final String accumulateRule;
  final int accumulate;
  final int maxAccumulate;
  final int curAccumulate;
  final String curAccumulateState;
  final String criterion;
  final int sort;
  final String accumulateTypeName;

  bool get isCompleted => curAccumulate >= maxAccumulate;
}
