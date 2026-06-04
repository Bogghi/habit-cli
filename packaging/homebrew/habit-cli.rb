# Homebrew formula for habit-cli.
#
# This is the canonical copy. To publish it, copy this file to
# `Formula/habit-cli.rb` in the tap repo `Bogghi/homebrew-habit-cli`.
#
# After each release, update `version` and the two `sha256` values. The
# checksums are published by the release workflow as
# `habit-cli-macos-arm64.tar.gz.sha256` and `habit-cli-macos-x64.tar.gz.sha256`
# on the GitHub Release — copy the hash from each sidecar file here.
class HabitCli < Formula
  desc "Terminal habit tracker with GitHub-style heatmaps"
  homepage "https://github.com/Bogghi/habit-cli"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Bogghi/habit-cli/releases/download/v1.0.0/habit-cli-macos-arm64.tar.gz"
      sha256 "REPLACE_WITH_ARM64_SHA256"
    else
      url "https://github.com/Bogghi/habit-cli/releases/download/v1.0.0/habit-cli-macos-x64.tar.gz"
      sha256 "REPLACE_WITH_X64_SHA256"
    end
  end

  def install
    bin.install "habit-cli"
  end

  test do
    # The app is an interactive TUI; piping `q` makes it initialize and quit
    # cleanly, which exercises the binary without hanging.
    assert_predicate bin/"habit-cli", :executable?
    pipe_output("#{bin}/habit-cli", "q")
  end
end
