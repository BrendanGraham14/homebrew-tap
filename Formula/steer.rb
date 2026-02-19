class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/BrendanGraham14/steer"
  version "0.14.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.1/steer-aarch64-apple-darwin.tar.xz"
      sha256 "16757b13000bc4256fc214e143f0d3228d4b93e1728515e475e0f402410ebed2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.1/steer-x86_64-apple-darwin.tar.xz"
      sha256 "af9a1736c16479081c07bed5a06da098191e234119dad47386dc68e7786536bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.1/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27ba7edbe6be1de997f53c821a42f398edc27f60a26ac75a2ff2b49145204a2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BrendanGraham14/steer/releases/download/steer-v0.14.1/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a460ec2192ea7ce6f0230311bde11c41e5e23eed0ce5956593ea17b810feea24"
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
