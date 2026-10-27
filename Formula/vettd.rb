class Vettd < Formula
  desc "Detect, analyze, and report AI execution artifacts"
  homepage "https://github.com/AgenticHighway/vettd-cli"
  version "0.12.0"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-arm64.tar.gz"
      sha256 "dd18dc040bd88438ae5a371cc3ab204e9356f1e5be6c56205494bcfbcd6dd676"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-darwin-amd64.tar.gz"
      sha256 "3488a93f498984024fa305d42bb2ad500ccdf5d09cdd85668645289b2af399ed"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-arm64.tar.gz"
      sha256 "88cd37346ddd312b6ef66047664b1e4675f4a1a33cc59d774c74b3ca0e5a2976"
    else
      url "https://github.com/AgenticHighway/vettd-cli/releases/download/v#{version}/vettd-linux-amd64.tar.gz"
      sha256 "f96efa26db774e8b841fa70a0abdd596bebd6e78bbfd5705632b6a7da30fc6a2"
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
