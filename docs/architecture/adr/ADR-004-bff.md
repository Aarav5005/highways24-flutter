# ADR 004: Backend for Frontend (BFF) Pattern

- **Status**: Approved
- **Date**: 2026-07-31
- **Deciders**: Principal Platform Architect, Lead DevOps Engineer

## Context
Mobile clients operating on 2G/3G connections cannot perform multiple HTTP round-trips to separate microservices without severe latency penalties.

## Decision
We introduce a **Backend for Frontend (BFF)** layer between the Flutter mobile app and internal backend services. The BFF aggregates payloads, handles mobile-specific response formatting, and optimizes bandwidth.

## Consequences
- **Positive**: Single round-trip data fetching for mobile clients, smaller JSON payloads, decouples Flutter from internal backend refactoring.
- **Negative**: Adds a thin orchestration layer to maintain in the backend repository.
