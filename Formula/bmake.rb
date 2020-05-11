class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200506.tar.gz"
  sha256 "0ac33c9bb00f12e54a3571e492f8c88cd835f6df64533d008e188a47373538e2"

  bottle do
    sha256 "c027553fb2c3e1f79fbb864aecd512b24c60b1b523448f182b93f1993217e128" => :catalina
    sha256 "c15535d267ea85166113773e9ea682882e29fe4ad72e8b21a99e0c2ceecb7fd0" => :mojave
    sha256 "076e094ee3890830515fa79abc9e7a0213d901d86739bb48f31e05099ab89d0b" => :high_sierra
    sha256 "369acfa84015a4ec2a33c8f035066b4e988fb64a8e11feb9a26c47e007aa45d4" => :x86_64_linux
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args

    chmod "u+w", man1/"bmake.1"
    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
