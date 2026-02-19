class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/BrendanGraham14/steer"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "e458096f3d93410080ae870dd148376130b1383252d083bd8f4da23dde4d8f27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "24c67e3880273d9b65fef7ea7c24069f9082a4febafdb04e20fc7ac9d99ba333"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "99e2f8e6a5e94a720633b95a1b3c09eeef6a33451c3e85f73d440ec9c1139ce8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f23ba1f4976510373b7d55877d7a8386744195a6602c4ab199d2061076dc474d"
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
