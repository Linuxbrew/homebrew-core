class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.19.tar.gz"
  sha256 "e93466735ac9c34d68b7d5d71f32c16a2b4b1a6a1adffb85acc4126a3398b9d0"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"
  revision 2 unless OS.mac?

  bottle do
    cellar :any
    sha256 "4090a7f985abe855d3725014be8c6922008d98ff2f5ff10983637b6a4ed3bb59" => :catalina
    sha256 "f537513011bf038e306282adce8c65e18dcbcc0a486106819bca019e746fc257" => :mojave
    sha256 "5066a95f9ab62623f012d4930171e41cbd1fef9be916c661dc6817c20ed5f97c" => :high_sierra
    sha256 "d5f181ce2ec72efdcd6e9d380dcbb9bf37f2ee8d60325b601d987ddffe35a5a3" => :x86_64_linux
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"
  depends_on "python@3.8" unless OS.mac?

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
