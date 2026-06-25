class Vettd < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/vettd-cli"
  version "0.8.4"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-arm64.tar.gz"
      sha256 "336c394be02d5b90d6f85cda2c3ec657abadc25fdd4c4c946a4a2cdb7e05dc68"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-amd64.tar.gz"
      sha256 "774d36ead9302ef9b9cc223fb030c8e53418575a56d96001e3e04009f638ef31"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-arm64.tar.gz"
      sha256 "9e6a086c0efc622b45c70c3288de165bb6329a028b0a79f3e5bf397b87223806"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-amd64.tar.gz"
      sha256 "080cafcc05c6373f501431a98bb6ccbfe59563e9eed0d0f5e04d08f0fdd149da"
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
