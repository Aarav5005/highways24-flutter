import '../../../models/dhaba_model.dart';
import 'dhaba_search_query.dart';

abstract class DhabaRepository {
  Future<List<DhabaModel>> getNearbyDhabas();
  Future<DhabaModel?> findDhabaById(String id);
  Future<List<DhabaModel>> searchDhabas(DhabaSearchQuery query);
}
