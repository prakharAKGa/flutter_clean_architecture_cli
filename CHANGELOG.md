# Changelog

## 1.1.0

- **FIX**: Improved argument parsing for CLI commands (`--name` and other flags are now correctly recognized).
- **DOC**: Added `dartdoc` comments to public API elements for better documentation and package score.
- **DOC**: Added `example/` directory with `README.md` and `main.dart` usage examples.
- **CHORE**: Updated dependencies (`args`, `mason_logger`, `path`, `yaml`) to latest stable versions.
- **CHORE**: Updated package homepage and repository URLs.

## 1.0.0

- 🎉 Initial release
- ✅ `create` command: generates complete clean architecture structure with core layer
- ✅ `feature` command: generates a full feature with BLoC, domain, data, and presentation layers
- ✅ Core layer: ApiClient (Dio), Interceptors, Failures, Exceptions, Theme, Colors, DI (GetIt), NetworkInfo, UseCase base
- ✅ Feature layer: Entity, Model (fromJson/toJson), Repository (abstract + impl), UseCase, BLoC (event/state/bloc), Page, Widget
- ✅ All generated files include helpful TODO comments for guided setup
