import '../entities/accumulate_entity.dart';

abstract interface class AccumulateRepository {
  Future<List<AccumulateEntity>> getTodayAccumulate({required String pid});
}
