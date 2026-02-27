import '../../domain/entities/accumulate_entity.dart';

class AccumulateModel extends AccumulateEntity {
  const AccumulateModel({
    required super.accumulateId,
    required super.accumulateName,
    required super.accumulateRule,
    required super.accumulate,
    required super.maxAccumulate,
    required super.curAccumulate,
    required super.curAccumulateState,
    required super.criterion,
    required super.sort,
    required super.accumulateTypeName,
  });

  factory AccumulateModel.fromJson(Map<String, dynamic> json) {
    return AccumulateModel(
      accumulateId: json['AccumulateId'] as String? ?? '',
      accumulateName: json['AccumulateName'] as String? ?? '',
      accumulateRule: json['AccumulateRule'] as String? ?? '',
      accumulate: json['Accumulate'] as int? ?? 0,
      maxAccumulate: json['MaxAccumulate'] as int? ?? 0,
      curAccumulate: json['CurAccumulate'] as int? ?? 0,
      curAccumulateState: json['CurAccumulateState'] as String? ?? '',
      criterion: json['Criterion'] as String? ?? '',
      sort: json['Sort'] as int? ?? 0,
      accumulateTypeName: json['AccumulateTypeName'] as String? ?? '',
    );
  }
}
