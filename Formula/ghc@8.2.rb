require "language/haskell"

class GhcAT82 < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.2.2/ghc-8.2.2-src.tar.xz"
  sha256 "bb8ec3634aa132d09faa270bbd604b82dfa61f04855655af6f9d14a9eedc05fc"

  bottle do
    rebuild 1
    sha256 "e8b7dbca371f1c62de38dd06dcd9e90d638acf2e2f6b61b087a0eb043ebbbfd7" => :mojave
    sha256 "b1f1d079df456ce6297160e75766cd8016737bfaefee52cd29eeabddc302d4fd" => :high_sierra
    sha256 "a3a80024bb1535107f78646d0d806efb1a794d132e52aa5a39e47fac24d5c275" => :sierra
  end

  keg_only :versioned_formula

  depends_on "python" => :build
  depends_on "sphinx-doc" => :build
  unless OS.mac?
    depends_on "m4" => :build
    # This dependency is needed for the bootstrap executables.
    depends_on "gmp" => :build
    depends_on "ncurses"
  end

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
    sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  end

  # https://www.haskell.org/ghc/download_ghc_8_0_1#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  resource "binary" do
    if OS.linux?
      url "https://downloads.haskell.org/~ghc/8.2.2/ghc-8.2.2-x86_64-deb8-linux.tar.xz"
      sha256 "48e205c62b9dc1ccf6739a4bc15a71e56dde2f891a9d786a1b115f0286111b2a"
    else
      url "https://downloads.haskell.org/~ghc/8.2.2/ghc-8.2.2-x86_64-apple-darwin.tar.xz"
      sha256 "d774e39f3a0105843efd06709b214ee332c30203e6c5902dd6ed45e36285f9b7"
    end
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/8.2.2/ghc-8.2.2-testsuite.tar.xz"
    sha256 "927ff939f46a0f79aa87e16e56e0a024a288c78259bed874cb15aa96a653566c"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j2" if ENV["CIRCLECI"]

    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"

    # Build a static gmp rather than in-tree gmp, otherwise it links to brew's.
    gmp = libexec/"integer-gmp"

    # GMP *does not* use PIC by default without shared libs  so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      if OS.mac?
        args = "--build=#{Hardware.oldest_cpu}-apple-darwin#{`uname -r`.to_i}"
      else
        args = "--build=core2-linux-gnu"
      end
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                            *args
      system "make"
      system "make", "check"
      ENV.deparallelize { system "make", "install" }
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib"]

    # As of Xcode 7.3 (and the corresponding CLT) `nm` is a symlink to `llvm-nm`
    # and the old `nm` is renamed `nm-classic`. Building with the new `nm`, a
    # segfault occurs with the following error:
    #   make[1]: * [compiler/stage2/dll-split.stamp] Segmentation fault: 11
    # Upstream is aware of the issue and is recommending the use of nm-classic
    # until Apple restores POSIX compliance:
    # https://ghc.haskell.org/trac/ghc/ticket/11744
    # https://ghc.haskell.org/trac/ghc/ticket/11823
    # https://mail.haskell.org/pipermail/ghc-devs/2016-April/011862.html
    # LLVM itself has already fixed the bug: llvm-mirror/llvm@ae7cf585
    # rdar://25311883 and rdar://25299678
    if DevelopmentTools.clang_build_version >= 703 && DevelopmentTools.clang_build_version < 800
      args << "--with-nm=#{`xcrun --find nm-classic`.chomp}"
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    resource("testsuite").stage { buildpath.install Dir["*"] }
    cd "testsuite" do
      system "make", "clean"
      system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
    end

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
  end
end
