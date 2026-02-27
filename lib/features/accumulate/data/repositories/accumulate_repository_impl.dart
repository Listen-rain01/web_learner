import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/accumulate_entity.dart';
import '../../domain/repositories/accumulate_repository.dart';
import '../datasources/accumulate_remote_datasource.dart';

part 'accumulate_repository_impl.g.dart';

class AccumulateRepositoryImpl implements AccumulateRepository {
  const AccumulateRepositoryImpl(this._dataSource);

  final AccumulateRemoteDataSource _dataSource;

  @override
  Future<List<AccumulateEntity>> getTodayAccumulate({required String pid}) =>
      _dataSource.getTodayAccumulate(pid: pid);
}

@riverpod
AccumulateRepository accumulateRepository(Ref ref) {
  return AccumulateRepositoryImpl(ref.watch(accumulateRemoteDataSourceProvider));
}
