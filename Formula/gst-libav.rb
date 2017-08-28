class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.12.2.tar.xz"
  sha256 "5bb735b9bb218b652ae4071ea6f6be8eaae55e9d3233aec2f36b882a27542db3"

  bottle do
    sha256 "ef02406cd8c80e24c2c20a0e740da7fc1c25b7f1b0c7a498183e19a1fb82c64e" => :sierra
    sha256 "d2fb5b14923c2f6b093c1b316f8f650249c425dbdca8b27ea0b0d9a1234ec548" => :el_capitan
    sha256 "61dc84774a2f55a0bc6e167589a56f200b2bdf09325d1908d07298482ea87bb5" => :yosemite
    sha256 "07b2acfe6dbd79f1bf05ed0b45f8e7bcda4c4ef058e6d4f75cd582c73b85f5aa" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-libav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
