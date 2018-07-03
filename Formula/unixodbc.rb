class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.6.tar.gz"
  sha256 "88b637f647c052ecc3861a3baa275c3b503b193b6a49ff8c28b2568656d14d69"

  bottle do
    sha256 "cd5a1ea2f0ba6db321b63514b2c33c0c1d74ada9541de8390cca0bc349f4845d" => :high_sierra
    sha256 "2ccf3f7384697dd2460631a4afb685465a93c8f64fb0217c7485ab8919606e7d" => :sierra
    sha256 "3330aee67c21712979a5e0cca8360f691b3e3bd0dd751fdeb15af998d2e6814c" => :el_capitan
    sha256 "17d3ae4d85f7db8255246e9df382faead0bf53d6cebae49a55edd9fce8ab8b97" => :x86_64_linux
  end

  depends_on "libtool"

  keg_only "shadows system iODBC header files" if OS.mac? && MacOS.version < :mavericks

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  depends_on "libtool" unless OS.mac?

  def install
    # Fixes "sed: -e: No such file or directory"
    # Reported 22 Mar 2018 to nick AT unixodbc DOT org
    inreplace "exe/Makefile.in", "@sed -i -e", "@sed -i '' -e" if OS.mac?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
