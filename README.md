# flutter_clean_architecture_cli 🏗️

[![pub version](https://img.shields.io/pub/v/flutter_clean_architecture_cli.svg)](https://pub.dev/packages/flutter_clean_architecture_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Dart SDK](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue)](https://dart.dev)

A powerful CLI tool that generates a **complete Flutter Clean Architecture** project structure with **BLoC state management** in one command. Stop copying boilerplate — start building features.

---

## ✨ What It Generates

### `create` command → Full Project Core
```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart          ← Dio HTTP client setup
│   │   ├── api_interceptor.dart     ← Request/response interceptors
│   │   └── api_endpoints.dart       ← Centralized endpoint paths
│   ├── errors/
│   │   ├── failures.dart            ← Domain-level failures (Either)
│   │   └── exceptions.dart          ← Data-layer exceptions
│   ├── theme/
│   │   ├── app_colors.dart          ← Brand color palette
│   │   ├── app_text_styles.dart     ← Typography styles
│   │   └── app_theme.dart           ← Light & dark ThemeData
│   ├── utils/
│   │   └── app_utils.dart           ← Shared utility functions
│   ├── constants/
│   │   └── app_constants.dart       ← API URLs, keys, timeouts
│   ├── network/
│   │   └── network_info.dart        ← Internet connectivity check
│   ├── di/
│   │   └── injection_container.dart ← GetIt dependency registration
│   └── usecases/
│       └── usecase.dart             ← Abstract UseCase base class
└── features/                        ← Your features go here
```

### `feature` command → Full Feature with BLoC
```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {name}_remote_datasource.dart   ← API calls (Dio)
│   │   └── {name}_local_datasource.dart    ← Caching (SharedPrefs/Hive)
│   ├── models/
│   │   └── {name}_model.dart               ← DTO with fromJson/toJson
│   └── repositories/
│       └── {name}_repository_impl.dart     ← Repo implementation
├── domain/
│   ├── entities/
│   │   └── {name}_entity.dart              ← Pure business entity
│   ├── repositories/
│   │   └── {name}_repository.dart          ← Abstract contract
│   └── usecases/
│       └── get_{name}.dart                 ← UseCase (dartz Either)
└── presentation/
    ├── bloc/
    │   ├── {name}_event.dart               ← BLoC events
    │   ├── {name}_state.dart               ← BLoC states
    │   └── {name}_bloc.dart                ← BLoC logic
    ├── pages/
    │   └── {name}_page.dart                ← Screen with BlocProvider
    └── widgets/
        └── {name}_widget.dart              ← Reusable UI widget
```

---

## 🚀 Installation

```bash
dart pub global activate flutter_clean_architecture_cli
```

Make sure your Dart pub cache `bin` folder is in your PATH:
- **macOS/Linux**: Add `export PATH="$PATH:$HOME/.pub-cache/bin"` to your `~/.zshrc` or `~/.bashrc`
- **Windows**: Add `%LOCALAPPDATA%\Pub\Cache\bin` to your system PATH

---

## 📖 Usage

### 1. Create a new project structure

```bash
clean_arch create --name my_app
```

Run this inside your existing Flutter project directory. It will generate the `lib/core/` folder and full project scaffolding.

### 2. Add a feature

```bash
clean_arch feature --name auth
clean_arch feature --name home
clean_arch feature --name product
clean_arch feature --name user_profile
```

### 3. Check version

```bash
clean_arch version
```

### 4. Get help

```bash
clean_arch --help
clean_arch create --help
clean_arch feature --help
```

---

## 📦 Required Dependencies

After generating your structure, add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  get_it: ^7.6.4
  dartz: ^0.10.1
  dio: ^5.4.0
  internet_connection_checker: ^1.0.0+1

  # Optional but recommended:
  shared_preferences: ^2.2.2   # For local caching
  hive_flutter: ^1.1.0         # Alternative local storage
```

Then run:
```bash
flutter pub get
```

---

## 🛠️ Post-Generation Setup

### Step 1 — Configure your API

Open `lib/core/constants/app_constants.dart`:
```dart
// TODO: Replace with your actual API base URL
static const String baseUrl = 'https://your-api.com/api/v1';
```

### Step 2 — Add your brand colors

Open `lib/core/theme/app_colors.dart`:
```dart
// TODO: Replace with your primary brand color
static const Color primary = Color(0xFF6200EE);
static const Color secondary = Color(0xFF03DAC6);
```

### Step 3 — Set up Dependency Injection

Open `lib/core/di/injection_container.dart` and register your feature dependencies:
```dart
// BLoC
getIt.registerFactory(() => AuthBloc(loginUseCase: getIt()));

// Use Cases
getIt.registerLazySingleton(() => LoginUseCase(getIt()));

// Repositories
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
    networkInfo: getIt(),
  ),
);
```

### Step 4 — Initialize DI in main.dart

```dart
import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize all dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const AuthPage(),
    );
  }
}
```

### Step 5 — Define your entity fields

Open `lib/features/auth/domain/entities/auth_entity.dart`:
```dart
class AuthEntity extends Equatable {
  final String id;
  final String email;      // Add your fields
  final String token;      // Add your fields
  final bool isVerified;   // Add your fields

  const AuthEntity({
    required this.id,
    required this.email,
    required this.token,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [id, email, token, isVerified];
}
```

### Step 6 — Update your model's fromJson

Open `lib/features/auth/data/models/auth_model.dart`:
```dart
factory AuthModel.fromJson(Map<String, dynamic> json) {
  return AuthModel(
    id: json['id'] as String,
    email: json['email'] as String,
    token: json['token'] as String,
    isVerified: json['is_verified'] as bool? ?? false,
  );
}
```

---

## 🧩 Full Example Workflow

```bash
# 1. Create a new Flutter project
flutter create my_shopping_app
cd my_shopping_app

# 2. Generate clean architecture structure
clean_arch create --name my_shopping_app

# 3. Add features
clean_arch feature --name auth
clean_arch feature --name product
clean_arch feature --name cart
clean_arch feature --name order

# 4. Add dependencies
flutter pub add flutter_bloc equatable get_it dartz dio internet_connection_checker

# 5. Run
flutter run
```

---

## 📝 Generated File Comments

Every generated file includes:
- A `// Generated by flutter_clean_arch_cli` header
- `// TODO:` comments guiding you on what to implement
- Inline documentation explaining each layer's responsibility

---

## 🏛️ Architecture Overview

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│   Page → BlocConsumer → Widget      │
│   BlocProvider → BLoC               │
└─────────────────┬───────────────────┘
                  │ dispatches events / receives states
┌─────────────────▼───────────────────┐
│            Domain Layer             │
│   BLoC → UseCase → Repository       │
│              (abstract)             │
└─────────────────┬───────────────────┘
                  │ implemented by
┌─────────────────▼───────────────────┐
│             Data Layer              │
│   RepositoryImpl → RemoteDataSource │
│                  → LocalDataSource  │
└─────────────────────────────────────┘
```

**Key principles:**
- The **domain layer** has zero Flutter/external dependencies (pure Dart)
- The **data layer** implements domain contracts — swappable without touching domain or presentation
- **BLoC** is the single source of truth for UI state — no business logic in widgets
- **GetIt** handles all dependency injection — no manual `new` calls in UI

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request on [GitHub](https://github.com/prakharAKGa/flutter_clean_architecture_cli.git).

---

## 📄 License

MIT © flutter_clean_architecture_cli
