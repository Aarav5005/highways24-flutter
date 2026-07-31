# Highways24 Engineering Handbook & Flutter Guidelines

## 1. Code Style & Standards
- Enforce strict static analysis using `flutter analyze` with zero warnings allowed before merging.
- Prefer `const` constructors wherever possible to optimize widget rebuild trees.
- Keep UI widgets thin; delegate all business logic to Application Services and Riverpod Notifiers.

## 2. Git Workflow & Branch Strategy
- Main branch: `main` (Production ready).
- Feature branches: `feat/feature-name` or `fix/issue-description`.
- Pull Requests require passing automated CI suite (`flutter test`, `flutter analyze`) and 1 code review approval.

## 3. Architecture Decision Records (ADR Rule)
- **Rule**: Any change to project architecture, state management patterns, or core networking requires an approved ADR in `docs/architecture/adr/`.
