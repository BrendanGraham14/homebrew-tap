class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/BrendanGraham14/steer"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.11.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "d8a45db37016aaa5954cd01b312373f014cf51dffb7431c9babc405de4b7c9bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.11.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "d5cb8495c296e02a159af1224392415f56038d3f46c15bf61d1828d941f3f901"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.11.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4d5a870043ae4a13ed6304cf667e96574c107b12d33822993c93b456361838de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.11.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ee14b57c8ea3574cce4c93af259c7b9e2cd7e42156bce64c0cfdf2db731f760"
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
