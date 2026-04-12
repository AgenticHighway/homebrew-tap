class Proov < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/proov"
  version "0.6.8"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-arm64.tar.gz"
      sha256 "9769d64f4b5da97718ad7e971c47011331adf82267669c41f8289d0c0cd5c980"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-amd64.tar.gz"
      sha256 "673c17740051914e409c6d1a0326a42a2fb9689658925c230116487fa25c12b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-arm64.tar.gz"
      sha256 "c29d6b0d5c28a9a311ff9f69c1d50fefa903ef5df68bcee72d55a99f683e6235"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-amd64.tar.gz"
      sha256 "a9a6ac8934be879ce72a707b205e17b0aba42c0de31c6408001ca5201f935f43"
    end
  end

  def install
    bin.install "proov"
  end

  test do
    (testpath/"agents.md").write <<~TEXT
      You are an autonomous coding agent.
      You may use shell commands and network access.
    TEXT

    output = shell_output("#{bin}/proov file #{testpath}/agents.md --json")
    assert_match "\"scanMeta\"", output
    assert_match "\"prompts\"", output
    assert_match "\"agents\"", output
  end
end
