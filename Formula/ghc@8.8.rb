class GhcAT88 < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.8.4/ghc-8.8.4-src.tar.xz"
  sha256 "f0505e38b2235ff9f1090b51f44d6c8efd371068e5a6bb42a2a6d8b67b5ffc2d"
  license "BSD-3-Clause"
  revision OS.mac? ? 1 : 2

  # Cellar should be :any_skip_relocation on Linux
  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "78a806d8c18645588e55422e2d67e19f1caaf8e869e98c7327a716a1ead63926"
    sha256 cellar: :any_skip_relocation, catalina:     "de4d4235c849b5c8f07a3b4604b1e1e3c50b88f0deb4e97f9846ab8dde0d5d56"
    sha256 cellar: :any_skip_relocation, mojave:       "96b82af24e29043cd4f4c66b6871d40913ac58e30e2c0fced9ca3cc043408778"
    sha256 cellar: :any_skip_relocation, high_sierra:  "9d5a52d029125c10744cf20c500ff84d9602fd32f6d81e9ca0137aba508a7ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0817dad180d333f9c5c025c565c4bd11c6b8e86f1dd8d2f328e68ba50cf9a9a4"
  end

  keg_only :versioned_formula

  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on arch: :x86_64

  unless OS.mac?
    depends_on "m4" => :build
    depends_on "ncurses"

    # This dependency is needed for the bootstrap executables.
    depends_on "gmp" => :build
  end

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
    sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  end

  # https://www.haskell.org/ghc/download_ghc_8_8_3.html#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.8.3/ghc-8.8.3-x86_64-apple-darwin.tar.xz"
      sha256 "7016de90dd226b06fc79d0759c5d4c83c2ab01d8c678905442c28bd948dbb782"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.8.3/ghc-8.8.3-x86_64-deb8-linux.tar.xz"
      sha256 "92b9fadc442976968d2c190c14e000d737240a7d721581cda8d8741b7bd402f0"
    end
  end

  def install
    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"

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

      unless OS.mac?
        # Explicitly disable NUMA
        args << "--enable-numa=no"

        # Disable PDF document generation
        (buildpath/"mk/build.mk").write <<-EOS
          BUILD_SPHINX_PDF = NO
        EOS
      end

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
