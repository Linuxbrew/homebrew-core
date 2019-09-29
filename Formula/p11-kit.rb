class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.17/p11-kit-0.23.17.tar.gz"
  sha256 "5447b25d66c05f86cce5bc8856f7a074be84c186730e32c74069ca03386d7c1e"

  bottle do
    sha256 "82ca19bc7ca3be640c16f9ba1329f563f093f6ee6fb3700d75786836aa8d94fc" => :catalina
    sha256 "6eef561b7f7159a96ae5d161fe0177e84fa0f929bbb89e799039cb1162d11387" => :mojave
    sha256 "f4035d5739c5bb31e6db0d523ee9b44e18a35f22bb73bf49fc2f1dd8035fac3f" => :high_sierra
    sha256 "de9ed5f549f2cb54e6228868a7724be6a1395ad5027ca753bb00068828c7a592" => :sierra
    sha256 "e7ee503880f2c45758a08199a2ae231f6ba095215f3bdcd4de5495d0ceb2dd6d" => :x86_64_linux
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "check" if OS.mac? # Takes more than 30 min on circle.ci
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
