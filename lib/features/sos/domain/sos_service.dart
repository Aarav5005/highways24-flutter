import '../../../models/sos_alert_model.dart';
import '../../../core/events/event_bus.dart';
import '../data/sos_api.dart';
import '../data/dto/sos_alert_dto.dart';

class SOSService {
  final SOSApi? _sosApi;
  final List<SOSAlertModel> _activeAlerts = [];

  SOSService([this._sosApi]);

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

    final api = _sosApi;
    if (api != null) {
      try {
        final dto = SOSAlertDto(
          id: sosAlert.id,
          driverId: sosAlert.driverId,
          driverName: sosAlert.driverName,
          driverPhone: sosAlert.driverPhone,
          locationAddress: sosAlert.locationAddress,
          latitude: sosAlert.latitude,
          longitude: sosAlert.longitude,
          timestamp: sosAlert.timestamp.toIso8601String(),
          status: 'active',
          notifiedContacts: sosAlert.notifiedContacts,
        );
        final resDto = await api.triggerSOS(dto);
        return resDto.toDomain();
      } catch (_) {
        // Resilient fallback to local active alert
      }
    }

    return sosAlert;
  }

  void resolveAlert(String sosId) {
    final index = _activeAlerts.indexWhere((s) => s.id == sosId);
    if (index >= 0) {
      _activeAlerts[index] = _activeAlerts[index].copyWith(status: SOSAlertStatus.resolved);
    }

    final api = _sosApi;
    if (api != null) {
      try {
        api.resolveSOS(sosId);
      } catch (_) {
        // Ignore network error on resolve
      }
    }
  }
}
