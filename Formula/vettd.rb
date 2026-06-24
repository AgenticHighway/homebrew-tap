class Vettd < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/vettd-cli"
  version "0.8.2"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-arm64.tar.gz"
      sha256 "84a1dde293946ddb2c3fa857e05b6a7c414ebfe0e9fdc56f3085517325e681ec"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-amd64.tar.gz"
      sha256 "add6aaafcaadcc256b72654a4693d8f0a9a6ca009c5817358364e6d523b9898b"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-arm64.tar.gz"
      sha256 "72b6c30fa1e70f426173530901b4c4c62504221ba7ea064d1e646fe43aee76f7"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-amd64.tar.gz"
      sha256 "5b2dbf3b1be58744877ce7805e489f218c6c8767a51d13f2e5c267ca3bd3e2b1"
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
