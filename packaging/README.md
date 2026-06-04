# Packaging & release runbook

This directory holds the distribution config for habit-cli. The build itself is
automated by `.github/workflows/release.yml`; the steps below are the per-release
manual follow-ups for the package managers.

## Cut a release

1. Bump `version:` in `pubspec.yaml` and add a `CHANGELOG.md` entry.
2. Commit, then tag and push:
   ```sh
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```
3. The `Release` workflow builds on macOS (Apple Silicon) and Windows (x64),
   then publishes a GitHub Release with these assets and their `.sha256` sidecars:
   - `habit-cli-macos-arm64.tar.gz`
   - `habit-cli-windows-x64.zip` (contains `habit-cli.exe` at the root)

## Homebrew (macOS)

Source formula: [`homebrew/habit-cli.rb`](homebrew/habit-cli.rb). The published copy
lives in the tap repo `Bogghi/homebrew-habit-cli` at `Formula/habit-cli.rb`.

Per release:
1. Update `version` in the formula.
2. Copy the macOS arm64 hash from the Release's `.sha256` file into `sha256`.
3. Commit to the tap repo. (First time only: create the tap repo, named
   `homebrew-habit-cli`, and copy the formula into `Formula/`.)
4. Verify:
   ```sh
   brew install bogghi/habit-cli/habit-cli
   habit-cli
   brew audit --strict --online bogghi/habit-cli/habit-cli
   ```

Install command for users: `brew install bogghi/habit-cli/habit-cli`

## winget (Windows)

Reference manifest: [`winget/`](winget/) (three files). The submission goes to
`microsoft/winget-pkgs` under `manifests/b/Bogghi/HabitCli/X.Y.Z/`.

Easiest path (on a Windows machine):
```powershell
winget install wingetcreate
# First release — interactive:
wingetcreate new https://github.com/Bogghi/habit-cli/releases/download/vX.Y.Z/habit-cli-windows-x64.zip
# Later releases — bump an existing package:
wingetcreate update Bogghi.HabitCli --version X.Y.Z `
  --urls https://github.com/Bogghi/habit-cli/releases/download/vX.Y.Z/habit-cli-windows-x64.zip `
  --submit
```
`wingetcreate` computes the SHA256 and opens the PR. For the portable nested
exe, ensure `NestedInstallerType: portable`, `RelativeFilePath: habit-cli.exe`,
and `PortableCommandAlias: habit-cli` (see the reference installer manifest).

Or hand-edit the files in `winget/` (update `PackageVersion`, `InstallerUrl`,
`InstallerSha256`), validate, and submit:
```powershell
winget validate .\winget\
winget install --manifest .\winget\   # local install test before the PR
```

Install command for users (after the PR merges): `winget install Bogghi.HabitCli`
