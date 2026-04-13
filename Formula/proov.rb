class Proov < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/proov"
  version "0.7.0"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-arm64.tar.gz"
      sha256 "6a5817c13755290cb5bcf289277fbf1f28843e9b36d29314382f00dd5338c16d"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-amd64.tar.gz"
      sha256 "a9b5ee81587f25266db89ea64824ab29ec9636aa82afbdf903d61c2397854f37"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-arm64.tar.gz"
      sha256 "a68bf18b5c239c5cc1fe2278569b6b8e9de6a02ea4088b4b668b2ca0f93cf894"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-amd64.tar.gz"
      sha256 "2f69dbbb4cea0706e3f89c53eab0336a9ea20dc6a6298e22e8e074d1ace333a4"
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
