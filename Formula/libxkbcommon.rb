class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.0.1.tar.xz"
  sha256 "ab68b25341c99f2218d7cf3dad459c1827f411219901ade05bbccbdb856b6c8d"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 "9b9a3ca86b9a7319a3cef8b1edb6c17e5dc6199a83bf61877975f16065d8fa82" => :catalina
    sha256 "10e46156eb6eece206f22f25e7662722490d56268cc54d34db1dab02aba8a3ca" => :mojave
    sha256 "b38bfdf4dba9b991117087b0276ffa7d1221bafbefc6247cc504c79c2cbb3a91" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 if OS.mac?

  uses_from_macos "libxml2" => :build

  unless OS.mac?
    depends_on "libxcb"
    depends_on "linuxbrew/xorg/xkeyboardconfig"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Denable-wayland=false", "-Denable-docs=false", ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
