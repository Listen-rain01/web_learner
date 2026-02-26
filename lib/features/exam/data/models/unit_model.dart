import '../../domain/entities/unit_entity.dart';

/// 单位数据模型
/// Units 字段格式: "id,name,fullname,code^id,name,fullname,code^..."
class UnitModel extends UnitEntity {
  const UnitModel({required super.id, required super.name});

  /// 解析 SelectExamType 返回的 Units 字符串
  static List<UnitModel> fromUnitsString(String units) {
    return units
        .split('^')
        .where((s) => s.trim().isNotEmpty)
        .map((s) {
          final fields = s.split(',');
          return UnitModel(
            id: fields.isNotEmpty ? fields[0] : '',
            name: fields.length > 1 ? fields[1] : '',
          );
        })
        .where((u) => u.id.isNotEmpty)
        .toList();
  }
}
