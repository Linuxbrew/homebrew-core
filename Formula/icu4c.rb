class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-66-1/icu4c-66_1-src.tgz"
  version "66.1"
  sha256 "52a3f2209ab95559c1cf0a14f24338001f389615bf00e2585ef3dbc43ecf0a2e"

  bottle do
    cellar :any
    sha256 "f01dbe4266d1180c1da01d973200ed897cfa8ec8bf505c0f57f7f693bc566062" => :catalina
    sha256 "60e51b89507cf03f1d6ed59deda226b600f96f763dea9a415dfa8ebb42c197a0" => :mojave
    sha256 "87f2446c5de0991c6bf959a61e63a746ebb6687f6bd68186ecd74ff6801a41b1" => :high_sierra
    sha256 "2d3ad8136ae3650424a0d3e34fe6ef4ccdec60a9d7b2a40c04745e0083bbe0e1" => :x86_64_linux
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
    ]

    args << "--with-library-bits=64" if OS.mac?
    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.readable? "/usr/share/dict/words"
      system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system "#{bin}/gendict", "--uchars", "hello", "dict"
    end
  end
end
