class Proov < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/proov"
  version "0.6.9"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-arm64.tar.gz"
      sha256 "07b324aca0a2789b0e460d156028e54aa5866f4b1341f48b69695f1082914b98"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-amd64.tar.gz"
      sha256 "94b609b8c5bb8004d5b3dedcd728a6b4342992d405c3883f81d58cd47902c834"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-arm64.tar.gz"
      sha256 "a9878e3f51e07114de60b3833a1bb7bc9489dce03858bad7d1d6720bbf75d4d0"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-amd64.tar.gz"
      sha256 "6f9ec440a527c5f041501d9619bcce3a2ddd9bf44423971791046850d3e2bdf1"
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
