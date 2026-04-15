class Kelvinclaw < Formula
  desc "Secure, stable, and modular harness for agentic AI workflows"
  homepage "https://github.com/AgenticHighway/kelvinclaw"
  version "0.2.6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "jq"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-arm64.tar.gz"
      sha256 "27917f40dfb26451247449c24443e5c4c68f65b739b055549fd6379eb4ec0895"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-macos-x86_64.tar.gz"
      sha256 "4446e737cd82fe586082dfa8184bf0c1230af3c6106c09f978236483a15ef7f4"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-arm64.tar.gz"
      sha256 "e3d008a2617e7d559f9d00050b56cb72a14d4918e29e830d02cd184ed0d90e87"
    else
      url "https://github.com/AgenticHighway/kelvinclaw/releases/download/v#{version}/kelvinclaw-#{version}-linux-x86_64.tar.gz"
      sha256 "335b2d581a9a29ac4bcc4ed86231f1a85dc1aa3c34da9b06750b216faab7abdc"
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
