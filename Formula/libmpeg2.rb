class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "https://libmpeg2.sourceforge.io/"
  url "https://libmpeg2.sourceforge.io/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libmpeg2.sourceforge.io/downloads.html"
    regex(/href=.*?libmpeg2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1eb4e3c113049194258bad418e3f1f68b840b46f6acb11be780ffae8adf8fd26"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "sdl"

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags "-std=gnu89"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/sample1.c"
  end

  test do
    system ENV.cc, "-I#{include}/mpeg2dec", pkgshare/"sample1.c", "-L#{lib}", "-lmpeg2"
  end
end
