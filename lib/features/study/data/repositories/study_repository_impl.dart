import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/knowledge_type_entity.dart';
import '../../domain/entities/study_material_entity.dart';
import '../../domain/repositories/study_repository.dart';
import '../datasources/study_remote_datasource.dart';

part 'study_repository_impl.g.dart';

class StudyRepositoryImpl implements StudyRepository {
  const StudyRepositoryImpl(this._dataSource);

  final StudyRemoteDataSource _dataSource;

  @override
  Future<List<KnowledgeTypeEntity>> getTypes({required String pid}) =>
      _dataSource.getTypes(pid: pid);

  @override
  Future<List<KnowledgeTypeEntity>> getChildTypes({
    required String typeId,
    required String departmentId,
  }) =>
      _dataSource.getChildTypes(typeId: typeId, departmentId: departmentId);

  @override
  Future<List<StudyMaterialEntity>> getMaterials({
    required String typeId,
    required String departmentId,
    required String pid,
  }) =>
      _dataSource.getMaterials(typeId: typeId, departmentId: departmentId, pid: pid);

  @override
  Future<bool> completeReading({
    required String pid,
    required String subjectId,
  }) =>
      _dataSource.completeReading(pid: pid, subjectId: subjectId);
}

@riverpod
StudyRepository studyRepository(Ref ref) {
  return StudyRepositoryImpl(ref.watch(studyRemoteDataSourceProvider));
}
