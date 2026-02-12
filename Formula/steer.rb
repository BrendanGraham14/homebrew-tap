class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/brendangraham14/steer"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "45fa434ab17069af04f503040387896651a5cee7f150b9f8a051e6d0dde8103b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "d411c502c540d554ff4282b0cdeb94f358126e0368b1154c892c00ffce6283cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4041a149365d015d080a0f1b2d24db1607ff2023d036df55e2e8f5824fe9b72d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "602584d526b8a8310779bd2be570061f364baa900156ab9ec607be0522aabd0a"
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
