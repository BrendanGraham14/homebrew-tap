class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/brendangraham14/steer"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "6a44372fe93d47d3b6c36836460ada113ea67351816d604094f1bbd024755ae2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "8412ddd8f09f500bb889b11cb0a3ba8d19ffad93a3a02a661c109aed13596ea1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "639996a693058bfe28c75252e51765fe265ff60d0a7ccac9e6a421a53b16d770"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "135e0edeb16e88133f883d24890101ee0b12ee40c9aef436205c49f6ee0bab56"
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
