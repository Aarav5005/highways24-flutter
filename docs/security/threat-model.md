# Highways24 Threat Model & Security Policy

## 1. Trust Boundaries
- **Mobile Client (Untrusted)**: Flutter application running on driver/partner devices.
- **API Gateway / BFF (Trusted)**: Handles SSL termination, JWT validation, and rate limiting.
- **Backend Microservices (Internal Trusted)**: Isolated inside private VPC.

## 2. Threat Analysis & Mitigations

| Threat Vector | Risk Level | Mitigation Strategy |
|---|---|---|
| **API Key Theft from APK** | High | Secrets injected via `--dart-define-from-file`, key obfuscation. |
| **JWT Access Token Interception** | Critical | HTTPS/TLS 1.3, SSL Certificate Pinning, AES-256 Encrypted Storage. |
| **Driver Location Tampering** | Medium | GPS spoofing detection via `geolocator` mock location checks. |
| **Database Tampering on Device** | High | Isar local DB encrypted using hardware-backed keys (`flutter_secure_storage`). |
