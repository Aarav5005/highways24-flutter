# ADR 002: Isar NoSQL for Local Offline Persistence

- **Status**: Approved
- **Date**: 2026-07-31
- **Deciders**: Principal Flutter Architect, Mobile Security Lead

## Context
Truck drivers and travelers routinely operate in 2G/3G highway connectivity shadow zones. Core application flows (Trip Navigation, Dhaba Menu, Offline Emergency Contacts) must remain functional offline.

## Decision
We select **Isar NoSQL** as the local client database for offline caching, paired with `flutter_secure_storage` for AES-256 database key encryption.

## Consequences
- **Positive**: Extremely fast C++ native speed, asynchronous query streams, schema migrations support.
- **Negative**: Requires code generation step (`build_runner`).
