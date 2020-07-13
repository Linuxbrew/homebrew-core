class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.1.2.tar.gz"
  sha256 "9b4e49153808fa4ff149221f64957dfe6f2dcecd400e3e29979f8baf6712ed45"
  license "Apache-2.0"

  bottle do
    sha256 "5aaaf5a31822a94384dbeed8f4ed04b66fb968861a1f5133051db887175e6c8f" => :catalina
    sha256 "7024bbfebf08a530f187f83dbec0529815457c6674cbb46fa95fc539228d2db3" => :mojave
    sha256 "1126a823dceca1dc64710bbad2d66f584a96abd53e29187e4a2620cd7c18e182" => :high_sierra
    sha256 "24b53ace2f87dceb9fcf101a6c36742d587a2e28e3076f9efe4e67a0b5e40f78" => :x86_64_linux
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on :xcode => :build if OS.mac?
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on :x11 if OS.mac?
  unless OS.mac?
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "systemd"
    depends_on "linuxbrew/xorg/xorg"
    depends_on "linuxbrew/xorg/wayland"
  end

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DWITH_X11=ON" << "-DBUILD_SHARED_LIBS=ON"
    unless OS.mac?
      cmake_args << "-DWITH_CUPS=OFF"
      # cmake_args << "-DWITH_FFMPEG=OFF"
      # cmake_args << "-DWITH_ALSA=OFF"
      # cmake_args << "-DWITH_LIBSYSTEMD=OFF"
    end
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    # failed to open display
    return if ENV["CI"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
