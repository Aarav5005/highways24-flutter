import '../../../models/sos_alert_model.dart';
import '../../../core/events/event_bus.dart';

class SOSService {
  final List<SOSAlertModel> _activeAlerts = [];

  List<SOSAlertModel> get activeAlerts => List.unmodifiable(_activeAlerts);

  Future<SOSAlertModel> triggerPanicSOS({
    required String driverId,
    required String driverName,
    required String driverPhone,
    required String locationAddress,
    required double latitude,
    required double longitude,
    required List<String> notifiedContacts,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final sosAlert = SOSAlertModel(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      locationAddress: locationAddress,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      status: SOSAlertStatus.active,
      notifiedContacts: notifiedContacts,
    );

    _activeAlerts.insert(0, sosAlert);

    // Publish In-Process Domain Event
    EventBus().publish(
      SOSActivatedEvent(
        sosId: sosAlert.id,
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    return sosAlert;
  }

  void resolveAlert(String sosId) {
    final index = _activeAlerts.indexWhere((s) => s.id == sosId);
    if (index >= 0) {
      _activeAlerts[index] = _activeAlerts[index].copyWith(status: SOSAlertStatus.resolved);
    }
  }
}
