import '../../../models/mechanic_model.dart';
import '../../../models/mechanic_request_model.dart';

abstract class MechanicRepository {
  Future<List<MechanicModel>> getMechanics();
  Future<MechanicModel?> getMechanicById(String id);
  Future<void> submitBreakdownRequest(MechanicRequestModel request);
}
