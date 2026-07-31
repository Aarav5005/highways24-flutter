import '../../../models/dhaba_model.dart';

abstract class DhabaRepository {
  Future<List<DhabaModel>> getDhabas();
  Future<DhabaModel?> getDhabaById(String id);
  Future<List<DhabaModel>> searchDhabas(String query);
}
