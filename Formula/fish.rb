class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.2.1/fish-3.2.1.tar.xz"
  sha256 "d8e49f4090d3778df17dd825e4a2a80192015682423cd9dd02b6675d65c3af5b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "10789988100d68aba59a0b2a77c8e081e6603a99e685a4e4bc793402f750e76b"
    sha256 cellar: :any,                 big_sur:       "a1fff416cb486056960c941fa366f817de8dbb020bcd5467f2c63bfc6189b9c5"
    sha256 cellar: :any,                 catalina:      "cffa526865c495b8647caab5b24f84641f509e0048d67b57da97b4968ac05b6d"
    sha256 cellar: :any,                 mojave:        "8f8e193e965064a81c1da63fcce32cc950d5c3d54c319eda252b2b30289c612e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3fe004fabfe9b812cfc370563f07013dd02cb143f670d67c4a3047c90a7de1"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", shallow: false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    on_macos do
      args << "-DSED=/usr/bin/sed"
    end
    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
