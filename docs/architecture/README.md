# Architecture Governance & ADR Index

This directory contains the permanent Architecture Decision Records (ADRs) for the **Highways24 Mobility Platform**.

## 📜 How ADRs Work
- **Rule**: Any change to project architecture, state management, persistence, networking stack, security model, or offline sync semantics requires an approved ADR.
- **Location**: `docs/architecture/adr/ADR-00X-<title>.md`
- **Template**: Use `docs/architecture/adr/adr-template.md`

## 🏷️ ADR Status Lifecycle
1. **Proposed**: Under review by Principal Architect & engineering team.
2. **Accepted**: Formally approved and binding for all features.
3. **Superseded**: Replaced by a newer ADR.

## 📑 Active ADR Index
- [ADR-001: Native Riverpod 2.x for State & DI](adr/ADR-001-riverpod.md)
- [ADR-002: Isar NoSQL for Local Offline Persistence](adr/ADR-002-isar.md)
- [ADR-003: Vendor-Agnostic Map Engine Abstraction](adr/ADR-003-map-provider.md)
- [ADR-004: Backend for Frontend (BFF) Pattern](adr/ADR-004-bff.md)
- [ADR-005: Offline Sync Engine & Background Queue](adr/ADR-005-offline-sync.md)
