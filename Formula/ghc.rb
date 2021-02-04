class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-src.tar.xz"
  sha256 "ccdc8319549028a708d7163e2967382677b1a5a379ff94d948195b5cf46eb931"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  # Cellar should be :any_skip_relocation on Linux
  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "5ed34f95506b09b1b722fbcbb2ab050854d1ade4dcc6c6b5a3220fd9f78a76f6"
    sha256 cellar: :any_skip_relocation, catalina:     "1259e7d41e9ba1c89f648e412d12c70f4472f96ba969741c116c157239699d9d"
    sha256 cellar: :any_skip_relocation, mojave:       "eb32eeadb989c83317d8509764f8c3584df9c7f5c168d930e074f24630c94969"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "820bf85702e3f48ec29b825528982fb28fa22524b5cd2f4b76b478ee91326d24"
  end

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build

  unless OS.mac?
    depends_on "m4" => :build
    depends_on "ncurses"

    # This dependency is needed for the bootstrap executables.
    depends_on "gmp" => :build
  end

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.xz"
    sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
  end

  # https://www.haskell.org/ghc/download_ghc_8_10_1.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-x86_64-apple-darwin.tar.xz"
      sha256 "2635f35d76e44e69afdfd37cae89d211975cc20f71f784363b72003e59f22015"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.10.3/ghc-8.10.3-x86_64-deb9-linux.tar.xz"
      sha256 "95e4aadea30701fe5ab84d15f757926d843ded7115e11c4cd827809ca830718d"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
    # executables link to Homebrew's GMP.
    gmp = libexec/"integer-gmp"

    # GMP *does not* use PIC by default without shared libs so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      args = if OS.mac?
        "--build=#{Hardware.oldest_cpu}-apple-darwin#{OS.kernel_version.major}"
      else
        "--build=core2-linux-gnu"
      end
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                            *args
      system "make"
      system "make", "install"
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib"]

    unless OS.mac?
      # Fix error while loading shared libraries: libgmp.so.10
      ln_s Formula["gmp"].lib/"libgmp.so", gmp/"lib/libgmp.so.10"
      ENV.prepend_path "LD_LIBRARY_PATH", gmp/"lib"
      # Fix /usr/bin/ld: cannot find -lgmp
      ENV.prepend_path "LIBRARY_PATH", gmp/"lib"
      # Fix ghc-stage2: error while loading shared libraries: libncursesw.so.5
      ln_s Formula["ncurses"].lib/"libncursesw.so", gmp/"lib/libncursesw.so.5"
      # Fix ghc-stage2: error while loading shared libraries: libtinfo.so.5
      ln_s Formula["ncurses"].lib/"libtinfo.so", gmp/"lib/libtinfo.so.5"
      # Fix ghc-pkg: error while loading shared libraries: libncursesw.so.6
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["ncurses"].lib
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    unless OS.mac?
      # Explicitly disable NUMA
      args << "--enable-numa=no"

      # Disable PDF document generation
      (buildpath/"mk/build.mk").write <<-EOS
        BUILD_SPHINX_PDF = NO
      EOS
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
    Dir.glob(lib/"*/package.conf.d/package.cache.lock") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
