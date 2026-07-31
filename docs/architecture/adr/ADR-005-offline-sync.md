# ADR 005: Offline Sync Engine with Background Queue

- **Status**: Approved
- **Date**: 2026-07-31
- **Deciders**: Principal Flutter Architect, Staff Mobile Engineer

## Context
Driver actions taken while disconnected (such as placing a food order or logging trip telematics) must be safely preserved and synchronized when connectivity is restored.

## Decision
We implement a local **Pending Action Queue** in Isar. Actions are written locally first, and a background synchronization worker drains the queue when online connectivity is confirmed, utilizing optimistic UI updates.

## Consequences
- **Positive**: Seamless offline user experience, zero data loss during signal drops.
- **Negative**: Requires handling conflict resolution (e.g. server timestamp wins).
