class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/brendangraham14/steer"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "9a6c41c6f9783d75615f529b35ecf525374357b1e29c2ec4d9e780ef96987129"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "aa79f861f3e40f0362bc4b05d5afb4c0671ef6da4cb4d50b435e94e07420a4e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96460a666c2343b4840e2b6ac0ccfb7cd404abf982c85638bc100290340c8e88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.10.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "732f397752428085624bfddfcfc9bfb461bf0f0df2ca0d9eb2ba883109c37330"
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
