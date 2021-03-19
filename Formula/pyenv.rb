class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/1.2.24.tar.gz"
  sha256 "91fedd92ecaf34d8c3f2add63ed6d42e8f937626c49a9a5cb8511e38e48fdb04"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "433f3684d795186f16ff6669dc28c5130f0627eeb624f5cdfd9292220ebe7e22"
    sha256 cellar: :any,                 big_sur:       "c059ce48f3caa8a7f7a260e18e4491eb70e8250feaef787998d65ec457d6bd46"
    sha256 cellar: :any,                 catalina:      "ea35df8bdb58da7af95f22c965b94dbfd62cd2c59482b85c5189ada6e2dea28a"
    sha256 cellar: :any,                 mojave:        "1802e9dbbda4d6c2e73fd0c414c36bc04772ce59c6f52e3f68ba4284184efccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c144d06fd780fd9beb6b2f0e8b3d2e895ae339a780f5089863a29e7beeacb2b2"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"
  depends_on "python@3.9" unless OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-versions", "system pyenv-which python", "system pyenv-which python3"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
