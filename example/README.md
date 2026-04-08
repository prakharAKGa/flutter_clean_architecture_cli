# Flutter Clean Architecture CLI Example

This directory contains examples for using the `flutter_clean_architecture_cli`.

## How to use

The most common way to use this tool is as a CLI. 

1. Install the CLI:
   ```bash
   dart pub global activate flutter_clean_architecture_cli
   ```

2. Create a new Clean Architecture project structure:
   ```bash
   clean_arch create --name my_awesome_app
   ```

3. Add a new feature to your project:
   ```bash
   cd my_awesome_app
   clean_arch feature --name user_profile
   ```

## Programmatic Usage

You can also use the runner programmatically in your own Dart scripts:

```dart
import 'package:flutter_clean_architecture_cli/flutter_clean_architecture_cli.dart';

void main() async {
  // Run the CLI with custom arguments
  await run(['create', '--name', 'example_app']);
}
```
