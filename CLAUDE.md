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

This is a Dart `nocterm` TUI app for habit tracking.

- `bin/habit_cli.dart` — entry point; loads the store and calls `runApp(HabitApp(...))`
- `lib/habit_cli.dart` — `HabitApp` root widget and global key navigation
- `lib/models/` — `Habit` and `HabitLog` value objects
- `lib/storage/` — `StorageService` (JSON I/O) and `HabitStore` (in-memory state)
- `lib/screens/` — `DashboardScreen`, `LogTodayScreen`, `ManageHabitsScreen`
- `lib/widgets/` — `HeatmapCell`, `HeatmapGrid`, `NavBar`
- `test/habit_cli_test.dart` — unit tests using `package:test`

`nocterm` (a Flutter-like terminal UI framework) is declared in `pubspec.yaml`. The app compiles
to a self-contained native binary via `dart compile exe` — no Dart SDK is needed at runtime.

Linting follows `package:lints/recommended.yaml` (configured in `analysis_options.yaml`).

## Distribution

Releases are cut by pushing a `v*` tag, which triggers `.github/workflows/release.yml`. That
workflow compiles native binaries on macOS (arm64 + Intel x64) and Windows (x64) — Dart cannot
cross-compile, so each runs on its own runner — and attaches archives + SHA256 sidecars to a
GitHub Release.

- **Homebrew (macOS)**: tap repo `Bogghi/homebrew-habit-cli`; `brew install bogghi/habit-cli/habit-cli`
- **winget (Windows)**: package `Bogghi.HabitCli` (portable installer type); reference manifest
  kept under `packaging/winget/`

Bump `version:` in `pubspec.yaml` and the `CHANGELOG.md` entry before tagging a new release, then
update the Homebrew formula URLs/sha256 and the winget manifest for the new version.
