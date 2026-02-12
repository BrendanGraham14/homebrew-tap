class Steer < Formula
  desc "Command-line interface for Steer coding agent."
  homepage "https://github.com/brendangraham14/steer"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-aarch64-apple-darwin.tar.xz"
      sha256 "742192c778e25aa738bd05d5ac728bd17c2bccdd54e94e35fe77af1f658a1185"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-x86_64-apple-darwin.tar.xz"
      sha256 "3129f4253288f678f461b216220d409749df5d8d778820cd5839d91e87dc5277"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc71bd06d149b198ce6bb47cc07ae01fcbd95428539fbb72e1b62b93504ad520"
    end
    if Hardware::CPU.intel?
      url "https://github.com/brendangraham14/steer/releases/download/steer-v0.9.0/steer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e4053dc1c4cfd2563d71c94e9bfc2e4fccc44ad6897180bbe16f0636fbc6f8e"
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
