class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/BrendanGraham14/steer"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.17.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "6f2adbfd6a529a760209e206a45172af68ff4bb1c4d3b993a154196fb952d2c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.17.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "043073330cac8b80186d6791390aa7a002ba402e46eaa1bbaeae525752af5646"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.17.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b135d427707db100ab043aa0fff5a6771aef0925a1982b9158ddca0f60e7ea6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.17.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "12ba864ccc101de8152e5d9aab19ff9645fa7625a7217f77a413c015ba0df41f"
    end
  end
  license "AGPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "schema-generator", "steer" if OS.mac? && Hardware::CPU.arm?
    bin.install "schema-generator", "steer" if OS.mac? && Hardware::CPU.intel?
    bin.install "schema-generator", "steer" if OS.linux? && Hardware::CPU.arm?
    bin.install "schema-generator", "steer" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
