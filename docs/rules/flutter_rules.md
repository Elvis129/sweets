# Flutter Game Project Rules & Architecture

This document defines the **rules and best practices** for all Flutter Android game projects in this organization. Use this as a reference and starting context for every new project.

## 1. Project Structure & Modularization
- **Feature-first folder structure**: Organize by features/screens (e.g., `/features/loading/`, `/features/welcome/`).
- **Features/screens** depend only on core modules, not on each other.

## 2. Separation of Concerns
- **UI Layer**: Widgets, screens, and presentation logic only.
- **Business Logic Layer**: Use BLoC, Cubit, or event-based state management.
- **Data Layer**: Data fetching, caching, analytics, etc.
- **Service Layer**: Platform-specific integrations if needed.

## 3. Event-Based Communication
- **Event bus or state management** (BLoC, Provider, Riverpod) for module communication.
- **No direct calls** between unrelated modules; use events, streams, or DI.
- **Dialog system** exposes events/streams for showing/hiding dialogs.

## 4. Screens & Navigation
- **Use a router/navigation manager** appropriate for the project requirements.
- **Each screen is self-contained**; communicate via navigation or events.

## 5. Dialog System
- **Centralized dialog management** (e.g., DialogService).
- **Dialogs triggered by events** (confirmation, alert, options).
- **Support for custom dialogs and easy extension**.

## 6. Custom Font
- **Declare fonts in `pubspec.yaml`** and use globally via `ThemeData`.
- **No hardcoded font styles**; use theme extensions.

## 7. General Principles
- **Loose coupling**: Modules interact via interfaces, events, or DI.
- **High cohesion**: Each module has a single responsibility.
- **Testability**: Code is unit/widget testable.
- **Replaceability**: Any module can be swapped with minimal changes.
- **Documentation**: Document module APIs and event contracts.
- **All debug logs (Flutter, in-app) must be turned off in release builds.** Use kDebugMode in Flutter. Create a wrapper method to print debug logs in one line.
- **Consider implementing a centralized logging system to manage log visibility and routing based on build type.**

## 8. What to Avoid
- No direct dependencies between features/screens.
- No business logic in UI widgets.
- No hardcoded strings, URLs, or config values.
- No in-app purchases, ads, or backend except privacy policy and customer support links.

## 9. Platform-Specific Code
- **Expose only necessary APIs** to Flutter via platform channels.

### 9.1 Android BuildConfig Usage
- **Use BuildConfig fields** for app constants and configuration values.
- **Define common constants in `defaultConfig`** to avoid duplication across build types.
- **Use standard `BuildConfig.DEBUG`** for debug logging in Kotlin instead of custom debug flags.

### 9.2 Debug vs Release Build Control
- **Ensure release builds have zero debug output** for security and performance.

## 10. Updating & Extending
- **Add new features/screens** as new modules without modifying existing ones.
- **Update core modules** without breaking feature modules.
- **Use dependency injection** (e.g., `get_it`, `provider`) for easy swapping/updating of services.

## 11. Flutter packages
- Use the latest package versions available.
- Regularly check if packages need to be updated and update their versions
- Downgrade packages version only if meet compatibility issues

---

## Summary Table

| Concern         | Solution/Rule                                                                 |
|-----------------|-------------------------------------------------------------------------------|
| Modularization  | Feature-first, core modules, DI                                               |
| Separation      | UI, Logic, Data, Service layers                                               |
| Communication   | Event-based, streams, no direct calls                                         |
| Dialogs         | Centralized, event-driven, extensible                                         |
| Navigation      | Router, self-contained screens                                                |
| Custom Font     | Theme-based, no hardcoding                                                    |
| Platform Code   | Isolated, minimal API to Flutter, BuildConfig constants, BuildConfig.DEBUG for logging |
| Extensibility   | Add/replace modules with minimal changes                                      |

