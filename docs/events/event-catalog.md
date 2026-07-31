# Highways24 Event Catalog

This document details all domain events published by the client application and backend microservices.

## 1. Core Domain Events

### `TripStarted`
- **Producer**: Trip Feature / Navigation Service
- **Consumers**: Telematics Engine, Analytics, Driver Rewards
- **Payload**: `{ tripId, driverId, origin, destination, timestamp, startLat, startLng }`

### `OrderPlaced`
- **Producer**: Food Cart / Dhaba Feature
- **Consumers**: Dhaba Kitchen Partner App, Order Stepper, Analytics
- **Payload**: `{ orderId, driverId, dhabaId, items, totalAmount, paymentMethod, timestamp }`

### `SOSActivated`
- **Producer**: SOS Emergency Feature
- **Consumers**: Highway Patrol Helpline (1033), Emergency SMS Service, Police Dashboard
- **Payload**: `{ sosId, driverId, latitude, longitude, address, timestamp }`

### `MechanicRequested`
- **Producer**: Mechanics Feature
- **Consumers**: Mechanic Partner Dashboard, Dispatch Engine, SMS Alert
- **Payload**: `{ requestId, driverId, serviceType, vehicleNumber, locationAddress, timestamp }`
