# gcab: Build a bottle for Linux
class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.4/gcab-1.4.tar.xz"
  sha256 "67a5fa9be6c923fbc9197de6332f36f69a33dadc9016a2b207859246711c048f"

  bottle do
    sha256 "e570c13861c6c889291e1fc67a12c6f0df05129f2e9e80e52b3dbd1a0c406e94" => :catalina
    sha256 "e566c9d61568f0b6d22be4b9c0775f5b200c891683f9f31c00dc52305a31334a" => :mojave
    sha256 "0da87712672a12d33556616f283722e9b5684f929e21f91b011e9381d189eba3" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end
