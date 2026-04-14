class Kelvinclaw < Formula
  desc "Secure, stable, and modular harness for agentic AI workflows"
  homepage "https://github.com/AgenticHighway/kelvinclaw"
  version "0.2.3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "jq"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-arm64.tar.gz"
      sha256 "1d4643c4487b0a8b16aaf24b61f0bfb44200728f616a7da806968b18772f2be8"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-x86_64.tar.gz"
      sha256 "15a82a5c44ef80b15fe4c0734cac158ef395c68e9377673605ae4032db6dcf1a"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-arm64.tar.gz"
      sha256 "1c7d193ef328161a82c90b024bc48ca88ddd7136f2ce4198fa4db074d447a560"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-x86_64.tar.gz"
      sha256 "1931436495c2793f01dfd88c3ac869b490d7508776b5244007145a98580edd8d"
    end
  end

  def install
    bundle_root = buildpath.glob("kelvinclaw-*").find(&:directory?)
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

      To get started:
        cp #{opt_libexec}/kelvinclaw/.env.example .env
        kelvin-gateway start
        kelvin-tui
    EOS
  end

  test do
    assert_match "Release-bundle launcher for KelvinClaw", shell_output("#{bin}/kelvin --help")
    assert_match "Lifecycle manager for the kelvin-gateway daemon", shell_output("#{bin}/kelvin-gateway --help")
    assert_match "Kelvin Plugin Manager", shell_output("#{bin}/kpm --help")
    assert_match "Release-bundle launcher for kelvin-tui", shell_output("#{bin}/kelvin-tui --help")
  end
end
