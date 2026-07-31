import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/sos_alert_model.dart';
import '../domain/sos_service.dart';

final sosServiceProvider = Provider<SOSService>((ref) => SOSService());

final sosNotifierProvider = StateNotifierProvider<SOSNotifier, List<SOSAlertModel>>((ref) {
  return SOSNotifier(ref.watch(sosServiceProvider));
});

class SOSNotifier extends StateNotifier<List<SOSAlertModel>> {
  final SOSService _sosService;

  SOSNotifier(this._sosService) : super([]);

  Future<void> triggerSOS({
    required String driverId,
    required String driverName,
    required String driverPhone,
    required String locationAddress,
    required double latitude,
    required double longitude,
    required List<String> notifiedContacts,
  }) async {
    await _sosService.triggerPanicSOS(
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      locationAddress: locationAddress,
      latitude: latitude,
      longitude: longitude,
      notifiedContacts: notifiedContacts,
    );

    state = List.from(_sosService.activeAlerts);
  }

  void resolveSOS(String sosId) {
    _sosService.resolveAlert(sosId);
    state = List.from(_sosService.activeAlerts);
  }
}
