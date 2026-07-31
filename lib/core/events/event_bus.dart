import 'dart:async';

abstract class DomainEvent {
  final DateTime timestamp;
  DomainEvent() : timestamp = DateTime.now();
}

class OrderPlacedEvent extends DomainEvent {
  final String orderId;
  final String driverId;
  final String dhabaId;
  final double totalAmount;

  OrderPlacedEvent({
    required this.orderId,
    required this.driverId,
    required this.dhabaId,
    required this.totalAmount,
  });
}

class MechanicRequestedEvent extends DomainEvent {
  final String requestId;
  final String driverId;
  final String mechanicId;
  final String serviceType;

  MechanicRequestedEvent({
    required this.requestId,
    required this.driverId,
    required this.mechanicId,
    required this.serviceType,
  });
}

class SOSActivatedEvent extends DomainEvent {
  final String sosId;
  final String driverId;
  final double latitude;
  final double longitude;

  SOSActivatedEvent({
    required this.sosId,
    required this.driverId,
    required this.latitude,
    required this.longitude,
  });
}

class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController<DomainEvent> _streamController = StreamController<DomainEvent>.broadcast();

  Stream<T> on<T extends DomainEvent>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void publish(DomainEvent event) {
    _streamController.add(event);
  }
}
