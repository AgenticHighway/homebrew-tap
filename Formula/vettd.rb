class Vettd < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/vettd-cli"
  version "0.8.1"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install "vettd"
  end

  test do
    (testpath/"agents.md").write <<~TEXT
      You are an autonomous coding agent.
      You may use shell commands and network access.
    TEXT

    output = shell_output("#{bin}/vettd file #{testpath}/agents.md --json")
    assert_match "\"scanMeta\"", output
    assert_match "\"prompts\"", output
    assert_match "\"agents\"", output
  end
end
