# libusbmuxd: Build a bottle for Linux
class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  revision 1

  stable do
    url "https://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
    sha256 "1aa21391265d2284ac3ccb7cf278126d10d354878589905b35e8102104fec9f2"

    # Backport of upstream security fix for CVE-2016-5104.
    patch do
      url "https://github.com/libimobiledevice/libusbmuxd/commit/4397b3376dc4.patch?full_index=1"
      sha256 "b28e17c82dc11320741d33cf68fd78e1baec9e4133f5265b944f167839cbe9bb"
    end
  end
  bottle do
    cellar :any
    sha256 "da715ab9973ef748f7edec181f6e4d694a9d36d14bcca279f3734eb307c7782e" => :catalina
    sha256 "d96ad61ee9e0a3eb547cc80a2423fafa43397f627012a7ea5e9c3ed3b6fe8a3a" => :mojave
    sha256 "f388c09dd9a8a8d86cba0eff7af3426cb6ffeff127182ba8aabd91a290565873" => :high_sierra
  end


  head do
    url "https://git.sukimashita.com/libusbmuxd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iproxy"
  end
end
