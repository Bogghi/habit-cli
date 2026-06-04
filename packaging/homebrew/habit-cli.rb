# Homebrew formula for habit-cli.
#
# This is the canonical copy. To publish it, copy this file to
# `Formula/habit-cli.rb` in the tap repo `Bogghi/homebrew-habit-cli` and fill in
# the real `sha256`.
#
# After each release, update `version` and the `sha256` value. The checksum is
# published by the release workflow as `habit-cli-macos-arm64.tar.gz.sha256` on
# the GitHub Release — copy the hash from that sidecar file here.
#
# Apple Silicon only. Intel Macs are not supported (no macos-x64 build).
class HabitCli < Formula
  desc "Terminal habit tracker with GitHub-style heatmaps"
  homepage "https://github.com/Bogghi/habit-cli"
  url "https://github.com/Bogghi/habit-cli/releases/download/v1.0.0/habit-cli-macos-arm64.tar.gz"
  version "1.0.0"
  sha256 "REPLACE_WITH_ARM64_SHA256"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "habit-cli"
  end

  test do
    # The app is an interactive TUI; piping `q` makes it initialize and quit
    # cleanly, which exercises the binary without hanging.
    assert_predicate bin/"habit-cli", :executable?
    pipe_output(bin/"habit-cli", "q")
  end
end
