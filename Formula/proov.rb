class Proov < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/proov"
  version "0.6.7"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-arm64.tar.gz"
      sha256 "9b39f0512a87fdba5982e020364044786d2a5600662c4931609b677dea274282"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-darwin-amd64.tar.gz"
      sha256 "f0b3eb03b6640e251e91b2ddb52feaabaa563a661ed2841c30548acc6125b3d7"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-arm64.tar.gz"
      sha256 "fab290e98ab9fc4b8350cab01590ec2c1839eb45308aec4814a74a9ef042843e"
    else
      url "https://github.com/AgenticHighway/proov/releases/download/v#{version}/proov-linux-amd64.tar.gz"
      sha256 "fee63503c03dc67a8b3369b40ddd781b5cd6d5e44b4912868006d13d474eaebf"
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
    assert_match "\"artifacts\"", output
  end
end
