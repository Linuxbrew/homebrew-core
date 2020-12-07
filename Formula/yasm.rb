class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "https://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ca95cb3c02508796ff4e60d54146b03016b93e80837916359912ebf737a37562" => :big_sur
    sha256 "0eac94b60093266b44d12bdc53b4c828e0967c20a1d7d6005aa1dce8514b9f9b" => :arm64_big_sur
    sha256 "9aa61930f25fe305dc5364e72f539b0a225702b5f1dc222a9dde1216e901f7ab" => :catalina
    sha256 "0dc797b72ee3bad9c6a52276c871ac745207b5626722e805fa642d7a872847fc" => :mojave
    sha256 "7f31deeff91c5929f2cd52eca6b636669f9c8966f6d4777e89fa4b04e541ad85" => :high_sierra
    sha256 "150f48e9cf55d8bd0c2f37cdc792c35ea0bd14973b82e56ea93248dbbe0f7ff1" => :x86_64_linux
  end

  head do
    url "https://github.com/yasm/yasm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --disable-python
    ]

    # https://github.com/Homebrew/legacy-homebrew/pull/19593
    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.asm").write <<~EOS
      global start
      section .text
      start:
          mov     rax, 0x2000004 ; write
          mov     rdi, 1 ; stdout
          mov     rsi, qword msg
          mov     rdx, msg.len
          syscall
          mov     rax, 0x2000001 ; exit
          mov     rdi, 0
          syscall
      section .data
      msg:    db      "Hello, world!", 10
      .len:   equ     $ - msg
    EOS
    system "#{bin}/yasm", "-f", "macho64", "test.asm"
    return unless OS.mac?

    system "/usr/bin/ld", "-macosx_version_min", "10.8.0", "-static", "-o", "test", "test.o"
    system "./test"
  end
end
