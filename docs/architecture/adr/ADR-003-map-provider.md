# ADR 003: Vendor-Agnostic Map Engine Abstraction

- **Status**: Approved
- **Date**: 2026-07-31
- **Deciders**: Principal Flutter Architect, Staff Systems Engineer

## Context
Relying directly on `google_maps_flutter` throughout the UI creates tight coupling and exposes the platform to financial risks from Google Maps API price changes.

## Decision
We abstract all map rendering, marker clustering, and polyline operations behind a vendor-agnostic `MapProvider` interface. Feature screens interact only with the interface.

## Consequences
- **Positive**: Zero vendor lock-in. Ability to hot-swap between Google Maps, Mapbox, or OpenStreetMap via remote config.
- **Negative**: Requires writing bridge adapters for each map provider SDK.
