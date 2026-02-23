class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/BrendanGraham14/steer"
  version "0.16.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.16.1/steer-aarch64-apple-darwin.tar.xz"
      sha256 "9d2440479618f290262eeff3255188880fe5c9655080568b38ea2a1593c019b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.16.1/steer-x86_64-apple-darwin.tar.xz"
      sha256 "5fff37cd1d88b9dc3adea9979b916765f610bc27180884e5aa358ae5b7ba0714"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.16.1/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f64a1f4fc3ef162ae75db53da0c941bbb3e458516593ee615fd914c1e1341758"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.16.1/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cc25061d9511e9d88d3cfc0a0e8f929bcf4d15b9c3216c25f5bd1762b6a2ccd3"
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
