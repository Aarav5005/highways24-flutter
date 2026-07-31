import '../../../models/dhaba_model.dart';

abstract class DhabaSorter {
  List<DhabaModel> sort(List<DhabaModel> dhabas);
}

class DistanceSorter implements DhabaSorter {
  const DistanceSorter();

  @override
  List<DhabaModel> sort(List<DhabaModel> dhabas) {
    final list = List<DhabaModel>.from(dhabas);
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }
}

class RatingSorter implements DhabaSorter {
  const RatingSorter();

  @override
  List<DhabaModel> sort(List<DhabaModel> dhabas) {
    final list = List<DhabaModel>.from(dhabas);
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list;
  }
}
