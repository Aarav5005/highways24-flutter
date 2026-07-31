# Highways24 Production Release Pipeline & Deployment Checklist

This document details the release engineering pipeline, environment setup, build flavors, observability configurations, and security audit checklist for deploying Highways24 to Staging and Production.

---

## 🌐 1. Environment Configurations (`lib/app/env/app_env.dart`)

Highways24 supports 6-stage environment switching via `--dart-define=ENVIRONMENT=<env>`:

| Environment | Purpose | Base URL Target |
|---|---|---|
| `dev` | Active developer local work | `https://dev-api.highways24.in/v1` |
| `qa` | QA automated testing | `https://qa-api.highways24.in/v1` |
| `uat` | User Acceptance Testing | `https://uat-api.highways24.in/v1` |
| `staging` | Production-mirror staging environment | `https://staging-api.highways24.in/v1` |
| `prod` | Live Production environment | `https://api.highways24.in/v1` |

---

## 🔒 2. Security Audit & Log Redaction Checklist

- [x] **Token Storage**: AES-256 hardware-backed encryption via `FlutterSecureStorage`.
- [x] **Log Redaction**: Automatic stripping of JWT access tokens, refresh tokens, and passwords in `AppLogger` logs.
- [x] **Idempotency Keys**: UUID v4 headers (`idempotencyKey`) on transactional endpoints.
- [x] **TLS Certificate Validation**: Enforcement of HTTPS TLS 1.3 across all endpoints.

---

## 📊 3. Observability & Operational Telemetry

- **HTTP Request Tracing**: Outbound `X-Request-ID` and `correlationId` header injection.
- **Sync Queue Diagnostics**: Operational tracking of `totalQueued`, `totalCompleted`, `totalFailed`, and `deadLetterQueue` depth.
- **Crash Reporting**: Interception of unhandled Flutter & platform exceptions.

---

## 🚀 4. Release Build Commands

### Android Production APK & Bundle
```bash
# Build Android App Bundle (AAB) for Google Play
flutter build appbundle --release --dart-define=ENVIRONMENT=prod

# Build Android APK
flutter build apk --release --dart-define=ENVIRONMENT=prod
```

### iOS Production IPA
```bash
# Build iOS Release IPA for TestFlight / App Store
flutter build ipa --release --dart-define=ENVIRONMENT=prod
```

---

## 🏁 5. Production Readiness Sign-off Criteria
1. `flutter analyze`: **0 errors, 0 warnings**.
2. `flutter test`: **100% test pass rate** across widget and integration test suites.
3. Staging API sanity check: Authentication, Dhaba Discovery, Cart Orders, Mechanic Dispatch, SOS, and Active Trips verified against staging endpoints.
