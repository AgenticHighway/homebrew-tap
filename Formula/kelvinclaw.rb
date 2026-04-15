class Kelvinclaw < Formula
  desc "Secure, stable, and modular harness for agentic AI workflows"
  homepage "https://github.com/AgenticHighway/kelvinclaw"
  version "0.2.7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "jq"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-arm64.tar.gz"
      sha256 "11483424fe4b87aaa41d965fa51d9175625c1089bd5bc8bc2b0ca917e0dae0ca"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-x86_64.tar.gz"
      sha256 "8b4e11e7c0345d065e7bfee792cabcee8421a21d33cbccbe1094fca0bb5fb90e"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-arm64.tar.gz"
      sha256 "2d1a589ab86d57dbb71330ce0a120f65aef04245e88cc0d75b349d50206b6e16"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-x86_64.tar.gz"
      sha256 "2ace8936ad185c7fb78cf492528d27f8b796db6b4c5b77788d012a72571a3192"
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
      (bin/command).write <<~SH
        #!/bin/bash
        exec "#{bundle_path}/#{command}" "$@"
      SH
      chmod 0555, bin/command
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
