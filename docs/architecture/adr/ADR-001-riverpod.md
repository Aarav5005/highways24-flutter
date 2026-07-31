# ADR 001: Riverpod 2.x for State Management & Dependency Injection

- **Status**: Approved
- **Date**: 2026-07-31
- **Deciders**: Principal Flutter Architect, Staff Systems Engineer

## Context
The application requires a compile-safe, testable state management and dependency injection solution. The legacy `AppState` monolith used standard `ChangeNotifier` / `Provider`, which suffered from global rebuild performance penalties, lack of auto-disposal, and rigid `BuildContext` coupling.

## Decision
We adopt **Riverpod 2.x natively** for both state management and dependency injection across the application. We explicitly avoid secondary DI frameworks like `Injectable` or `GetIt` to maintain a single DI system and minimize cognitive load.

## Consequences
- **Positive**: Compile-safe providers, zero runtime reflection, automatic state disposal when UI unmounts, easy provider overrides in unit tests.
- **Negative**: Team must follow strict Riverpod conventions (`WidgetRef`, `ConsumerWidget`).
