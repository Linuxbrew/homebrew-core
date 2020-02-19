class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.29.2.tar.gz"
  sha256 "bc2f36b5d4fc9890c69f607d54da873032628462e88c545dd633d2c787a544a5"

  bottle do
    cellar :any
    sha256 "4cdd660e64c7d78876a2ccf60eec8891f484cdd24e2c40ce36800828dffcce1c" => :catalina
    sha256 "5c40ac3daf8ba6022cd5229aac50458d80b14920ddd513f2e165b233c9e95e72" => :mojave
    sha256 "2f534f9efbdd387764924f2a9e3a08b435cab0ff0a0edabd6bafe8fa4123af6a" => :high_sierra
    sha256 "65f6f96f78e63ee61fe6789e68ff850953665531a647bc3ededfb3b1da24291c" => :x86_64_linux
  end

  depends_on "python" => :build unless OS.mac?
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Use system Python 2 on macOS and Python 3 on Linux.
    inreplace "Makefile", "python", "python3" unless OS.mac?

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
