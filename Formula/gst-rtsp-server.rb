class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.18.2.tar.xz"
  sha256 "973922aba65a1672a131527dee965fb09bab4bb996c351f0ee7f42f0d5b954e2"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b4317689acd1ab2242fbf79485c6e41d3f7b6022f655cc5a1c0051a0e83fa58f" => :big_sur
    sha256 "ad3491746d607e87f9d3c413f993e95deea5f9cb1838fbd3155a241a8ec78886" => :arm64_big_sur
    sha256 "6de0097ebaf534fd685c904cea67866f038bfecf37c81f18b002746194d3a73c" => :catalina
    sha256 "e02cd4c0dcb586239614eb6d7775956933a40661dc9d3863e6c11809463a6085" => :mojave
    sha256 "532e57504bc209061b317ba36faf464415f82f983f742cdd0fe2c39894b91d89" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dexamples=disabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match /\s#{version}\s/, output
  end
end
