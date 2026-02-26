/// 单位实体
class UnitEntity {
  const UnitEntity({
    required this.id,
    required this.name,
  });

  /// 单位 ID（来自 SelectExamType Units 字段 [0] 位）
  final String id;

  /// 单位名称（来自 Units 字段 [1] 位）
  final String name;
}
