class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-6.0.2.tar.gz"
  sha256 "81bf188333f89c976780a477af27f651f54aa7da9312303d8d1a804696d3edd3"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b4bc0394134840fcff8cde84516230f5e271f6d0dd7d200f03604f15a229d230" => :big_sur
    sha256 "93d653204d84f240df4e59db76d6831f32776ee1d4e43d14fbd03822bba52b5e" => :arm64_big_sur
    sha256 "09574ca127597134674931bea9c895d59d2db3d0de60f585b51332b79f4780fe" => :catalina
    sha256 "98cf6ec9a70800a279741c495a399da829052847324e79768b870d2e3314b51b" => :mojave
    sha256 "26071207b6c5c9fa3747187f0c4b88d305417d2a95f4349c0d8c95754ca95ad0" => :high_sierra
    sha256 "835b1a7bb644d9c6957fa013e8480c07d23535f7c85853d356e6b8e472ce30a2" => :x86_64_linux
  end

  def install
    # upstream doesn't particularly care about their unix targets,
    # so we do the dirty work of renaming their shared objects to
    # dylibs for them.
    inreplace "makefile", "libunrar.so", "libunrar.dylib" if OS.mac?

    system "make"
    bin.install "unrar"

    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"

    lib.install shared_library("libunrar")
  end

  test do
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data =  "UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE" \
            "QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA="

    rarpath.write data.unpack1("m")
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
