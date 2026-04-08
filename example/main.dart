import 'package:flutter_clean_architecture_cli/flutter_clean_architecture_cli.dart';

void main(List<String> arguments) async {
  // This is a simple example showing how to run the CLI programmatically.
  
  // Example: Show version
  await run(['--version']);
  
  // Example: Show help
  await run(['--help']);
}
