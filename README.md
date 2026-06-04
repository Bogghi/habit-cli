# habit-cli

A terminal habit tracker built with Dart and [nocterm](https://pub.dev/packages/nocterm). Log daily habits, visualise streaks with GitHub-style heatmaps, and manage your habit list — all from the command line.

## Features

- **Dashboard** — one summary heatmap for all habits combined, plus an individual heatmap per habit (last 52 weeks)
- **Daily log** — check off today's habits with a simple checkbox list
- **Manage habits** — add and delete habits; changes persist immediately
- **Local storage** — data saved to `%APPDATA%\habit_cli\data.json` (Windows) or `~/.habit_cli/data.json` (macOS/Linux); no account needed

## Install

### macOS — Homebrew

```sh
brew install bogghi/habit-cli/habit-cli
```

### Windows — winget

```powershell
winget install Bogghi.HabitCli
```

Both install a `habit-cli` command on your `PATH`. Run it with:

```sh
habit-cli
```

## Build from source

Requires the [Dart SDK](https://dart.dev/get-dart) ≥ 3.11.

```sh
dart pub get
dart run bin/habit_cli.dart
```

Or compile to a native executable:

```sh
dart compile exe bin/habit_cli.dart -o habit-cli
./habit-cli
```

## Keyboard shortcuts

### Global (any screen)

| Key | Action |
|-----|--------|
| `1` | Dashboard |
| `2` | Log Today |
| `3` | Manage Habits |
| `Tab` | Cycle to next screen |
| `q` | Quit |

### Log Today / Manage Habits lists

| Key | Action |
|-----|--------|
| `j` / `↓` | Move down |
| `k` / `↑` | Move up |
| `Space` / `Enter` | Toggle habit completion (Log Today) |
| `n` | Add new habit (Manage) |
| `d` | Delete focused habit (Manage) |
| `Esc` | Cancel text input |

## Data

All data is stored locally as JSON. No network access is required.

```
Windows:  %APPDATA%\habit_cli\data.json
macOS:    ~/.habit_cli/data.json
Linux:    ~/.habit_cli/data.json
```

## Development

```sh
dart test          # run all tests
dart analyze       # static analysis
dart format .      # format code
```

See [CLAUDE.md](CLAUDE.md) for the full command reference and architecture notes.

## Architecture

```
bin/habit_cli.dart          # entry point — loads store, calls runApp
lib/
  habit_cli.dart            # HabitApp root widget, global key navigation
  models/                   # Habit and HabitLog value objects
  storage/                  # StorageService (JSON I/O) + HabitStore (state)
  screens/                  # DashboardScreen, LogTodayScreen, ManageHabitsScreen
  widgets/                  # HeatmapCell, HeatmapGrid, NavBar
```

`HabitStore` is the single source of truth. It holds mutable lists in memory and persists asynchronously after every mutation. `StorageService` is intentionally thin (just `load` / `save`) so a remote backend (e.g. Supabase) can be swapped in later with minimal changes.
