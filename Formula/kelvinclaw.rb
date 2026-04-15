class Kelvinclaw < Formula
  desc "Secure, stable, and modular harness for agentic AI workflows"
  homepage "https://github.com/AgenticHighway/kelvinclaw"
  version "0.2.5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "jq"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-arm64.tar.gz"
      sha256 "ac94828e8198aa73452d8b9ffb89e19af4fc05618b6b6cba1ccf081114f25a53"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-x86_64.tar.gz"
      sha256 "802eb4ce6f3a9796bf2400bd038ea82eae6fd7477dc7f61d253c67ca248e5618"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-arm64.tar.gz"
      sha256 "a2911ddfe441ce9717bd7c8576dd0e5d54c1fbb1c228e34163092eadc69e29a0"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-x86_64.tar.gz"
      sha256 "7c26f2ff2285c4e8a379ace529eec69bb7d4cd3419f3d3f2d29658701220c022"
    end
  end

  def install
    bundle_root =
      if %w[kelvin kelvin-gateway kpm kelvin-tui].all? { |command| (buildpath/command).exist? }
        buildpath
      else
        buildpath.glob("kelvinclaw-*").find(&:directory?)
      end

    raise "Expected KelvinClaw release bundle" unless bundle_root

    bundle_path = libexec/"kelvinclaw"
    ignored_entries = %w[. ..].freeze
    bundle_contents = Dir["#{bundle_root}/*", "#{bundle_root}/.*"].reject do |path|
      ignored_entries.include?(File.basename(path))
    end
    bundle_path.install bundle_contents

    %w[kelvin kelvin-gateway kpm kelvin-tui].each do |command|
      (bin/command).write_exec_script(bundle_path/command)
    end
  end

  def caveats
    <<~EOS
      KelvinClaw's full release bundle is installed at:
        #{opt_libexec}/kelvinclaw

      Canonical config path:
        ~/.kelvinclaw/.env

      To get started:
        kelvin init
        kelvin
    EOS
  end

  test do
    assert_match "Release-bundle launcher for KelvinClaw", shell_output("#{bin}/kelvin --help")
    assert_match "Lifecycle manager for the kelvin-gateway daemon", shell_output("#{bin}/kelvin-gateway --help")
    assert_match "Kelvin Plugin Manager", shell_output("#{bin}/kpm --help")
    assert_match "Release-bundle launcher for kelvin-tui", shell_output("#{bin}/kelvin-tui --help")
  end
end
