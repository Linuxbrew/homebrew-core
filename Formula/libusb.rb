class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://github.com/libusb/libusb/releases/download/v1.0.21/libusb-1.0.21.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libu/libusb-1.0/libusb-1.0_1.0.21.orig.tar.bz2"
  sha256 "7dce9cce9a81194b7065ee912bcd55eeffebab694ea403ffb91b67db66b1824b"

  bottle do
    cellar :any
    sha256 "e42e21cc9b7cd4223eb8050680ada895bdfcaf9c7e33534002cd21af2f84baf8" => :sierra
    sha256 "e4902b528d0ea0df0d433e349709d3708a9e08191fd2f3c6d5f5ab2989766b9f" => :el_capitan
    sha256 "8831059f7585ed973d983dd82995e1732c240a78f4f7a82e5d5c7dfe27d49941" => :yosemite
    sha256 "c90cafb47be0d4a369f25677ba7620ff6a82c617528b7ead4fd3835eb15424f5" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  depends_on "systemd" if OS.linux? # for libudev

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.without? "runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "-L#{lib}", "-I#{include}/libusb-1.0",
             "listdevs.c", "-o", "test", "-lusb-1.0"
      system "./test"
    end
  end
end
