class Vettd < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/vettd-cli"
  version "0.14.1"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-arm64.tar.gz"
      sha256 "1ed305c3ee98c5a79cd2d81c068d3416ef22fbc7f865869c25b6b75970e306ea"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-amd64.tar.gz"
      sha256 "f4fad81f3629fac11d4d918af946dcd8e85136257b8e4bb3a226e7eeed0811d1"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-arm64.tar.gz"
      sha256 "8c0109670ceccfa3a5c28273e3ecd08d2a9361af61325bf7c6e815cc4df53179"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-amd64.tar.gz"
      sha256 "f55193b6215fbaf9e907a30b6217cb0fd1a5257ac5e659687b568a2ffb798080"
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
