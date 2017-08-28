class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.3.1.tar.gz"
  sha256 "312fb9dc75668addbc9c8f33c7fa198b0fc965c576386b8451397e06256eadc6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    prefix "/home/linuxbrew/.linuxbrew"
    cellar :any
    sha256 "8028e9b692dd03b96a4b059dabe819fde4ee749ed36081bfb2338d8c0472a088" => :x86_64_linux # glibc 2.19
  end

  option "without-pzstd", "Build without parallel (de-)compression tool"

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    if build.with? "pzstd"
      system "make", "-C", "contrib/pzstd", "googletest"
      system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
      bin.install "contrib/pzstd/pzstd"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    if build.with? "pzstd"
      assert_equal "hello\n",
        pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
    end
  end
end
