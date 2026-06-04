# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
# Run the app
dart run bin/habit_cli.dart

# Run all tests
dart test

# Run a single test file
dart test test/habit_cli_test.dart

# Static analysis (lint)
dart analyze

# Format code
dart format .

# Install dependencies
dart pub get

# Compile to native executable
dart compile exe bin/habit_cli.dart -o habit_cli
```

## Architecture

This is a Dart CLI app targeting a habit-tracking use case. The project is in early/scaffold stage.

- `bin/habit_cli.dart` — entry point; currently wires up a `nocterm` TUI (`runApp`/`Center`/`Text` widgets)
- `lib/habit_cli.dart` — library code imported by the entry point and tests
- `test/habit_cli_test.dart` — unit tests using `package:test`

**Key note**: `bin/habit_cli.dart` imports `package:nocterm/nocterm.dart` (a Flutter-like terminal UI framework for Dart), but `nocterm` is not yet declared in `pubspec.yaml`. Before running, add it as a dependency and run `dart pub get`.

Linting follows `package:lints/recommended.yaml` (configured in `analysis_options.yaml`).
